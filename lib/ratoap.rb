require 'redis'
require 'logger'
require 'active_support/core_ext/module'
require 'yaml'
require 'fileutils'

require_relative 'ratoap/version'
require_relative 'ratoap/configuration'
require_relative 'ratoap/redis_script'

module Ratoap

  mattr_accessor :logger
  mattr_accessor :redis

  self.logger = Logger.new(STDOUT)

  def self.load
    Configurtion.load_and_override

    self.redis = config.redis_proc.call

    RedisScript.load

  end

  def self.run_test
    require "open3"
    require "ratoap-driver-vagrant"

    log_file = File.join(Dir.pwd, '.ratoap', 'ratoap-driver-vagrant.log')
    FileUtils.rm_rf log_file if File.exists?(log_file)
    FileUtils.mkdir_p File.basename(log_file)
    FileUtils.touch log_file
    FileUtils.chmod 0777, log_file
    File.truncate log_file, 0

    log_synchronizer_process_pid = Process.fork do
      writer = File.open(log_file, 'r')
      writer.wait_readable
      while true
        if line = writer.gets
          puts line
        end
      end
    end

    Open3.popen3("ratoap-driver-vagrant -l #{log_file}") do |stdin, stdout, stderr, wait_thr|

      pid = wait_thr.pid

      stdin.close
      stdout.close
      stderr.close

      exit_status = wait_thr.value
    end

    Process.kill("HUP", log_synchronizer_process_pid)
  end

  def self.config
    Configurtion.config
  end

  def self.configure(&block)
    Configurtion.configure(&block)
  end

end

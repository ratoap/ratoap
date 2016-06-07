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

    logger_file = File.join(Dir.pwd, '.ratoap', 'ratoap-driver-vagrant.log')
    FileUtils.rm_rf logger_file if File.exists?(logger_file)
    FileUtils.mkdir_p File.basename(logger_file)
    FileUtils.touch logger_file

    Open3.popen3("ratoap-driver-vagrant -l #{logger_file}") do |stdin, stdout, stderr, wait_thr|

      pid = wait_thr.pid

      puts pid

      stdin.close


      stdout.close
      stderr.close

      exit_status = wait_thr.value

      puts exit_status
    end
  end

  def self.config
    Configurtion.config
  end

  def self.configure(&block)
    Configurtion.configure(&block)
  end

end

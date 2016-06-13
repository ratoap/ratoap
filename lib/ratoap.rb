require 'redis'
require 'logger'
require 'active_support/core_ext/module'
require 'yaml'
require 'fileutils'
require 'json'

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

    client_driver_vagrant_process_pid = Process.fork do
      Open3.popen3("ratoap-driver-vagrant -l #{log_file}") do |stdin, stdout, stderr, wait_thr|
        pid = wait_thr.pid
        exit_status = wait_thr.value
      end
    end

    client_names = []
    config.drivers.each do |driver|
      client_names << "driver_#{driver['name']}"
    end
    config.provisioners.each do |provisioner|
      client_names << "provisioner_#{provisioner['name']}"
    end

    redis.set "ratoap:client_conn:wait", client_names.to_json

    i = 0

    r = while i <= 10 do
      i += 1

      wait_conn_client_names = JSON.parse(redis.get("ratoap:client_conn:wait"))
      break 1 if wait_conn_client_names.size == 0

      redis.publish("ratoap:client_conn", JSON.dump({act: :wait, redis_scripts: RedisScript.data}))
      sleep 3
    end

    if r != 1
      redis.publish("ratoap:client_conn", JSON.dump({act: :quit}))
    end

    Process.kill("HUP", client_driver_vagrant_process_pid)
    Process.kill("HUP", log_synchronizer_process_pid)
  end

  def self.config
    Configurtion.config
  end

  def self.configure(&block)
    Configurtion.configure(&block)
  end

end

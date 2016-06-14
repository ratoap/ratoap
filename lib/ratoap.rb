require 'redis'
require 'logger'
require 'active_support/core_ext/module'
require 'yaml'
require 'fileutils'
require 'json'

require_relative 'ratoap/version'
require_relative 'ratoap/configuration'
require_relative 'ratoap/redis_script'
require_relative 'ratoap/sub_progress_log_synchronizer'
require_relative 'ratoap/sub_progress_client'

module Ratoap

  mattr_accessor :workdir
  mattr_accessor :logger
  mattr_accessor :redis

  self.workdir = File.join Dir.pwd, '.ratoap'
  self.logger = Logger.new(STDOUT)


  def self.load
    Configurtion.load_and_override

    self.redis = config.redis_proc.call

    RedisScript.load
  end

  def self.run_test
    require "open3"
    require "ratoap-driver-vagrant"

    sub_progress_log_synchronizer = Ratoap::SubProgressLogSynchronizer.new "ratoap-driver-vagrant"
    sub_progress_client = Ratoap::SubProgressClient.new "ratoap-driver-vagrant -l #{sub_progress_log_synchronizer.file}"

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

  end

  def self.config
    Configurtion.config
  end

  def self.configure(&block)
    Configurtion.configure(&block)
  end

end

require 'redis'
require 'logger'
require 'active_support/core_ext/module'
require 'yaml'
require 'fileutils'
require 'json'

require_relative 'ratoap/version'
require_relative 'ratoap/configuration'
require_relative 'ratoap/redis_script'
require_relative 'ratoap/client_progress'
require_relative 'ratoap/client_conn_progress'

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
    require "ratoap-driver-vagrant"

    client_progresses = []

    client_names.each do |client_name|
      client_progress = Ratoap::ClientProgress.new client_name
      client_progress.enable_log_sync
      client_progress.run

      client_progresses << client_progress
    end

    client_conn_progress = Ratoap::ClientConnProgress.new client_names
    client_conn_progress.run

    sleep 60
    client_conn_progress.exit

  end

  def self.client_names
    [].tap do |names|
      config.drivers.each do |driver|
        names << "driver-#{driver['name']}"
      end
      config.provisioners.each do |provisioner|
        names << "provisioner-#{provisioner['name']}"
      end
    end
  end

  def self.config
    Configurtion.config
  end

  def self.configure(&block)
    Configurtion.configure(&block)
  end

end

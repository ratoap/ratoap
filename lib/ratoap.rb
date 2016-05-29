require 'redis'
require 'logger'
require 'active_support/core_ext/module'
require 'yaml'

require_relative 'ratoap/version'
require_relative 'ratoap/configuration'

module Ratoap

  mattr_accessor :logger
  mattr_accessor :redis

  self.logger = Logger.new(STDOUT)

  def self.load
    conf_file = File.join Dir.pwd, '.ratoap.yml'
    conf = YAML.load_file conf_file

    if conf.key?('redis')
      config.redis_config = conf.fetch('redis')
    end
    self.redis = config.redis_proc.call

    if conf.key?('drivers')
      config.drivers = conf.fetch('drivers')
    end

    if conf.key?('provisioners')
      config.provisioners = conf.fetch('provisioners')
    end

    if conf.key?('platforms')
      config.platforms = conf.fetch('platforms')
    end

    if conf.key?('tests')
      config.tests = conf.fetch('tests')
    end

  end

  def self.run_test
    config.drivers
  end

  def self.config
    Configurtion.config
  end

  def self.configure(&block)
    Configurtion.configure(&block)
  end

end

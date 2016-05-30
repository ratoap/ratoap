require 'redis'
require 'logger'
require 'active_support/core_ext/module'
require 'yaml'

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
    puts RedisScript.data
  end

  def self.config
    Configurtion.config
  end

  def self.configure(&block)
    Configurtion.configure(&block)
  end

end

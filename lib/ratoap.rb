require 'redis'
require 'logger'
require 'active_support/core_ext/module'

require_relative 'ratoap/version'
require_relative 'ratoap/configuration'

module Ratoap

  mattr_accessor :logger
  mattr_accessor :redis

  def self.load
    self.logger = Logger.new(STDOUT)
    self.redis = config.redis_proc.call
  end

  def self.config
    Configurtion.config
  end

  def self.configure(&block)
    Configurtion.configure(&block)
  end

end

require "redis"

require "ratoap/version"
require "ratoap/configuration"

module Ratoap

  def self.config
    Configurtion.config
  end

  def self.configure(&block)
    Configurtion.configure(&block)
  end

end

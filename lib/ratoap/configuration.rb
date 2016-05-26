require 'active_support/configurable'

module Ratoap
  class Configurtion

    include ActiveSupport::Configurable

    config_accessor :redis_config do
      {
        host: '127.0.0.1',
        port: 6379,
        db: 0,
      }
    end

    config_accessor :redis_proc do
      ->(options = redis_config){ Redis.new options }
    end

  end
end

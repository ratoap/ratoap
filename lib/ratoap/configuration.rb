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

    config_accessor :drivers do
      [
        {
          name: 'vagrant_ruby',
          setting: {}
        }
      ]
    end

    config_accessor :provisioners do
      [
        {
          name: 'ansible_ruby',
          setting: {}
        }
      ]
    end

    config_accessor :platforms do
      [
        {
          name: 'ubuntu-14.04',
          driver: 'vagrant_ruby',
          driver_settings: {},
          provisioner: 'ansible_ruby',
          provisioner_setting: {}
        }
      ]
    end

    config_accessor :tests do
      []
    end

  end
end

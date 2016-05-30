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

    def self.load_and_override
      conf_file = File.join Dir.pwd, '.ratoap.yml'
      conf = YAML.load_file conf_file

      if conf.key?('redis')
        self.redis_config = conf.fetch('redis')
      end

      if conf.key?('drivers')
        self.drivers = conf.fetch('drivers')
      end

      if conf.key?('provisioners')
        self.provisioners = conf.fetch('provisioners')
      end

      if conf.key?('platforms')
        self.platforms = conf.fetch('platforms')
      end

      if conf.key?('tests')
        self.tests = conf.fetch('tests')
      end
    end

  end
end

require 'thor'

module Ratoap
  module CLI
    module Generators
      class InitGenerator < ::Thor::Group
        include ::Thor::Actions

        def self.source_root
          File.expand_path('../init_templates', __FILE__)
        end

        def create_config_file
          template ".ratoap.yml"
        end

        def create_work_dir
          empty_directory ".ratoap"
        end
      end
    end
  end
end
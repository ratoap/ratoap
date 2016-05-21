require "ratoap/cli/base"
require "ratoap/cli//generators/init_generator"

module Ratoap
  module CLI
    class Init < Base

      def run
        Ratoap::CLI::Generators::InitGenerator.start
      end

    end
  end
end

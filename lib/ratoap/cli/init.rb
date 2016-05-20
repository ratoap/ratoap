require "ratoap/cli//generators/init_generator"

module Ratoap
  module CLI
    class Init < Base

      def run
        Ratoap::CLI::Generators::InitGenerator.invoke
      end

    end
  end
end

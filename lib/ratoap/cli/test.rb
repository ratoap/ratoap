require_relative 'base'

module Ratoap
  module CLI
    class Test < Base

      def run
        Ratoap.load

        Ratoap.run_test
      end

    end
  end
end

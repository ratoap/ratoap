require_relative 'base'

module Ratoap
  module CLI
    class Test < Base

      def run
        Ratoap.load
      end

    end
  end
end

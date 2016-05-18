module Ratoap
  module CLI
    class Base

      attr_reader :global_options, :options, :args

      def initialize(global_options, options, args)
        @global_options = global_options
        @options = options
        @args = args
      end

      def run
      end

    end
  end
end

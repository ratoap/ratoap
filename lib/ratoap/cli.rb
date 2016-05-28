require 'gli'
require_relative 'cli/init'
require_relative 'cli/test'

module Ratoap
  module CLI
    include GLI::App
    extend self

    version Ratoap::VERSION

    program_desc 'Run any test on any platforms'

    desc 'Generate init files'
    command :init do |c|
      c.flag [:d, :driver], desc: 'set driver', type: String, default_value: 'vagrant'

      c.action do |global_options, options, args|
        Ratoap::CLI::Init.new(global_options, options, args).run()
      end
    end

    desc 'Run test'
    command :test do |c|

      c.action do |global_options, options, args|
        Ratoap::CLI::Test.new(global_options, options, args).run()
      end
    end

  end
end

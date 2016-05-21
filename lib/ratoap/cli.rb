require 'gli'
require "ratoap/cli/base"
require "ratoap/cli/init"

module Ratoap
  module CLI
    include GLI::App
    extend self

    version Ratoap::VERSION

    program_desc 'Run any test on any platforms'

    desc 'Init config files'
    command :init do |c|
      c.flag [:d, :driver], desc: 'set driver', type: String, default_value: 'vagrant'

      c.action do |global_options, options, args|
        Ratoap::CLI::Init.new(global_options, options, args).run()
      end
    end

  end
end

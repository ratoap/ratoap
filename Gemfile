source 'https://rubygems.org'

local_gemfile = File.expand_path('../Gemfile.local', __FILE__)
if File.exists?(local_gemfile)
  instance_eval File.read(local_gemfile)
end

# Specify your gem's dependencies in ratoap.gemspec
gemspec

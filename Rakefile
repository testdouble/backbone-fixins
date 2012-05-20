require 'rake/clean'
require 'jasmine-headless-webkit'
require 'jasmine/headless/task'
require 'js_rake_tasks'

include Rake::DSL if defined?(Rake::DSL)

CLEAN << "dist"

Jasmine::Headless::Task.new

task :example_app_cucumber do
  system "cd examples/some_rails_app && bundle exec cucumber"
end

task :default => ['jasmine:headless', 'coffee:compile', 'example_app_cucumber']


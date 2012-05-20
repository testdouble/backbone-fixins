require 'rake/clean'
require 'jasmine-headless-webkit'
require 'jasmine/headless/task'
require 'js_rake_tasks'
require 'bundler'

include Rake::DSL if defined?(Rake::DSL)

CLEAN << "dist"

Jasmine::Headless::Task.new

task :example_app_cucumber do
  Dir.chdir("examples/some_rails_app")

  Bundler.with_clean_env do
    system "bundle install"
    system "bundle exec cucumber"
  end

  fail unless $? == 0
end

task :default => ['jasmine:headless', 'coffee:compile', 'example_app_cucumber']


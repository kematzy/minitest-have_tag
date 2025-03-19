# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'minitest/test_task'
require 'rubocop/rake_task'
require 'rake/testtask'

Minitest::TestTask.create
RuboCop::RakeTask.new

Rake::TestTask.new(:spec) do |t|
  # load the `lib` folder, and the `test | spec` folder.
  t.libs = %w[lib spec]
  t.test_files = FileList['spec/**/*_spec.rb']
  # enable extra CLI output, including the CLI command for debugging
  t.verbose = true
end

task default: %i[rubocop coverage]

desc 'alias for spec task'
task test: :spec

desc 'Run specs with coverage'
task :coverage do
  ENV['COVERAGE'] = '1'
  Rake::Task['spec'].execute
end

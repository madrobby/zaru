require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
end

require 'rubocop/rake_task'

RuboCop::RakeTask.new(:rubocop)

desc 'Run tests'
task default: :test

require 'rspec/core/rake_task'
require 'bundler/gem_tasks'

# Default directory to look in is `/specs`
# Run with `rake spec`
RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = ['--color']
end

task :default => :spec

lib = File.expand_path('../lib', __FILE__)
puts "Lib = #{lib}"
#this will include the path in $LOAD_PATH unless it is already included
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
puts "loadpath = #{$LOAD_PATH}"

Dir.glob('tasks/*.rake').each { |r| import r }

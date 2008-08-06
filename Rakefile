require 'rubygems'
require 'hoe'
require './lib/days_and_times.rb'

Dir['tasks/**/*.rake'].each { |rake| load rake }

Hoe.new('days_and_times', DaysAndTimes::VERSION::STRING) do |p|
  p.author      = 'Daniel Parker'
  p.email       = 'gems@behindlogic.com'
  p.summary     = "Natural language method chaining for Time, Durations and the like."
  p.description = "Natural language method chaining for Time, Durations and the like."
  p.url         = 'http://github.com/dcparker/days_and_times'
  p.changes     = p.paragraphs_of('History.txt', 0..1).join("\n\n")
end

desc "Generate gemspec"
task :gemspec do |x|
  # Check the manifest before generating the gemspec
  manifest = %x[rake check_manifest]
  manifest.gsub!(/\(in [^\)]+\)\n/, "")

  unless manifest.empty?
    print "\n", "#"*68, "\n"
    print <<-EOS
  Manifest.txt is not up-to-date. Please review the changes below.
  If the changes are correct, run 'rake check_manifest | patch'
  and then run this command again.
EOS
    print "#"*68, "\n\n"
    puts manifest
  else
    gemspec = `rake debug_gem`
    gemspec.gsub!(/\(in [^\)]+\)\n/, "")
    File.open("days_and_times.gemspec", 'w') {|f| f.write(gemspec) }
  end
end
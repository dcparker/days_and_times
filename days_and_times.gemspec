Gem::Specification.new do |s|
  s.name = %q{days_and_times}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Daniel Parker"]
  s.date = %q{2008-08-06}
  s.description = %q{Natural language method chaining for Time, Durations and the like.}
  s.email = %q{gems@behindlogic.com}
  s.extra_rdoc_files = ["History.txt", "License.txt", "Manifest.txt", "README.txt"]
  s.files = ["History.txt", "License.txt", "Manifest.txt", "README.txt", "Rakefile", "lib/days_and_times.rb", "lib/days_and_times/duration.rb", "lib/days_and_times/numeric.rb", "lib/days_and_times/object.rb", "lib/days_and_times/time.rb", "spec/days_and_times/numeric_spec.rb", "spec/days_and_times_spec.rb", "spec/spec_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/dcparker/days_and_times}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{days_and_times}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Natural language method chaining for Time, Durations and the like.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2
  end
end

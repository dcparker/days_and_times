$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module DaysAndTimes #:nodoc:
  module VERSION #:nodoc:
    MAJOR = 0
    MINOR = 0
    TINY  = 1

    STRING = [MAJOR, MINOR, TINY].join('.')
  end
end

require 'days_and_times/duration'
require 'days_and_times/numeric'
require 'days_and_times/time'
require 'days_and_times/object'

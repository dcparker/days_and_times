$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module DaysAndTimes
  def self.VERSION
    '1.0.0'
  end
end

require 'days_and_times/duration'
require 'days_and_times/numeric'
require 'days_and_times/time'
require 'days_and_times/object'

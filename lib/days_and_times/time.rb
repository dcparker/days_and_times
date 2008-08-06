require 'time'
class Time
  def to_time
    self
  end

  # Returns a new Time where one or more of the elements have been changed according to the +options+ parameter. The time options
  # (hour, minute, sec, usec) reset cascadingly, so if only the hour is passed, then minute, sec, and usec is set to 0. If the hour and
  # minute is passed, then sec and usec is set to 0.
  def change(options)
    ::Time.send(
      self.utc? ? :utc_time : :local_time,
      options[:year]  || self.year,
      options[:month] || self.month,
      options[:day]   || options[:mday] || self.day, # mday is deprecated
      options[:hour]  || self.hour,
      options[:min]   || (options[:hour] ? 0 : self.min),
      options[:sec]   || ((options[:hour] || options[:min]) ? 0 : self.sec),
      options[:usec]  || ((options[:hour] || options[:min] || options[:sec]) ? 0 : self.usec)
    )
  end

  def day_name
    self.strftime("%A")
  end
  def month_name
    self.strftime("%B")
  end

  # Seconds since midnight: Time.now.seconds_since_midnight
  def seconds_since_midnight
    self.to_i - self.change(:hour => 0).to_i + (self.usec/1.0e+6)
  end

  # Returns a new Time representing the start of the day (0:00)
  def beginning_of_day
    (self - self.seconds_since_midnight).change(:usec => 0)
  end
  alias :midnight :beginning_of_day
  alias :at_midnight :beginning_of_day
  alias :at_beginning_of_day :beginning_of_day

  # Returns a new Time if requested year can be accomodated by Ruby's Time class
  # (i.e., if year is within either 1970..2038 or 1902..2038, depending on system architecture);
  # otherwise returns a DateTime
  def self.time_with_datetime_fallback(utc_or_local, year, month=1, day=1, hour=0, min=0, sec=0, usec=0)
    ::Time.send(utc_or_local, year, month, day, hour, min, sec, usec)
  rescue
    offset = if utc_or_local.to_sym == :utc then 0 else ::DateTime.now.offset end
    ::DateTime.civil(year, month, day, hour, min, sec, offset, 0)
  end

  # wraps class method time_with_datetime_fallback with utc_or_local == :utc
  def self.utc_time(*args)
    time_with_datetime_fallback(:utc, *args)
  end

  # wraps class method time_with_datetime_fallback with utc_or_local == :local
  def self.local_time(*args)
    time_with_datetime_fallback(:local, *args)
  end

  def self.tomorrow
    Time.now.beginning_of_day + 1.day
  end
  def tomorrow
    self.beginning_of_day + 1.day
  end
  def self.yesterday
    Time.now.beginning_of_day - 1.day
  end
  def yesterday
    self.beginning_of_day - 1.day
  end
  def self.today
    Time.now.beginning_of_day
  end
  def self.next_month
    today.change(:day => 1, :month => today.month + 1)
  end

  def until(end_time)
    Duration.new(end_time - self, self)
  end
  def through(duration)
    self.until(duration)
  end
  def for(duration)
    raise TypeError, "must be a Duration object." unless duration.is_a?(Duration)
    duration.start_time = self
    duration
  end
  def is_today?
    self.beginning_of_day == Time.today
  end
  def strfsql
    self.strftime("%Y-#{self.strftime("%m").to_i.to_s}-#{self.strftime("%d").to_i.to_s}")
  end
  def self.from_tzid(tzid) #We aren't handling the Time Zone part here...
     if tzid =~ /(\d\d\d\d)(\d\d)(\d\d)T(\d\d)(\d\d)(\d\d)Z/ # yyyymmddThhmmss
       Time.xmlschema("#{$1}-#{$2}-#{$3}T#{$4}:#{$5}:#{$6}")
     else
       return nil
     end
  end
  def humanize_time
    self.strftime("%M").to_i > 0 ? self.strftime("#{self.strftime("%I").to_i.to_s}:%M%p").downcase : self.strftime("#{self.strftime("%I").to_i.to_s}%p").downcase
  end
  def humanize_date(length_profile='medium') #There may be decent reason to change how this works entirely...
    case length_profile
    when 'abbr' || 'abbreviated'
      self.strftime("%m/%d/%y")
    when 'short'
      self.strftime("%b #{self.strftime("%d").to_i.to_s}")
    when 'medium'
      self.strftime("%B #{self.strftime("%d").to_i.to_s}")
    when 'long'
      self.strftime("%B #{self.strftime("%d").to_i.to_s}, %Y")
    end
  end
  def humanize_date_time
    self.humanize_date + ' ' + self.humanize_time
  end
end

def Today
  Time.today
end
def Yesterday
  Time.yesterday
end
def Tomorrow
  Time.tomorrow
end
def Now
  Time.now
end

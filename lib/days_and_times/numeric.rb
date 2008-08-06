require 'days_and_times/duration'
class Numeric
  def weeks
    self == 1 ? Week.new : Weeks.new(self)
  end
  def week
    self.weeks
  end

  def days
    self == 1 ? Day.new : Days.new(self)
  end
  def day
    self.days
  end

  def hours
    self == 1 ? Hour.new : Hours.new(self)
  end
  def hour
    self.hours
  end

  def minutes
    self == 1 ? Minute.new : Minutes.new(self)
  end
  def minute
    self.minutes
  end

  def seconds
    self == 1 ? Second.new : Seconds.new(self)
  end
  def second
    self.seconds
  end

  def is_multiple_of?(num)
    self % num == 0
  end
end

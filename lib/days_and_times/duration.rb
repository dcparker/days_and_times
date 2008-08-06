require 'time'
class Duration
  # Length is the length of the time span, in seconds
  # Unit is a length of time (in seconds) to use in collection methods
  # StartTime is an optional attribute that can 'anchor' a duration
  #   to a specific real time.
  attr_accessor :length, :unit, :start_time
  def initialize(count=0,unit=1,start_time=nil,auto_klass={})
    if unit.is_a?(Time) || unit.is_a?(DateTime)
      start_time = unit
      unit = 1
    end
    options = {:count => count || 0, :unit => unit || 1, :start_time => start_time}.merge(count.is_a?(Hash) ? count : {})

    @unit = options[:unit]
    @length = (@unit * options[:count].to_f).round
    @start_time = options[:start_time]
  end
  def self.new(*args)
    a = super
    if self.name == 'Duration' && (args.last.is_a?(Hash) ? args.last[:auto_class] == true : true)
      a.send(:auto_class)
    else
      a
    end
  end
  def self.length
    1
  end

  # * * * * * * * * * * * * * * * *
  # A Duration is a LENGTH of Time
  #   -This is measured in seconds,
  #    but set in terms of the unit
  #    currently being used.
  def length=(value)
    if value.respond_to?(:to_f)
      @length = (self.unit * value.to_f).round
    else
      raise TypeError, "Can't set a Duration's length to a #{value.class.name} object."
    end
  end
  def length
    length  = @length.to_f / self.unit
    length.to_i == length ? length.to_i : length
  end
  def abs_length=(value)
    if value.respond_to?(:to_i)
      @length = value.to_i
    else
      raise TypeError, "Can't set a Duration's length to a #{value.class.name} object."
    end
  end
  def abs_length
    @length
  end
  def to_i
    self.abs_length.to_i
  end
  def to_f
    self.abs_length.to_f
  end
  def to_s
    "#{self.length} #{self.class.name}"
  end
  def coerce(*args)
    to_f.coerce(*args)
  end

  def ===(other)
    self.to_f == other.to_f
  end
  def inspect
    "#<#{self.class.name}:#{self.object_id} (length=#{self.length.inspect}) #{self.instance_variables.reject {|d| d=='@length' || self.instance_variable_get(d).nil?}.collect {|iv| "#{iv}=#{self.instance_variable_get(iv).inspect}"}.join(' ')}>"
  end
  # * * * * * * * * * * * * * * * *

  # * * * * * * * * * * * * * * * * * * * * *
  # A Duration's calculations utilize a UNIT
  #   -This is stored as the number of
  #    seconds equal to the unit's value.
  def unit=(value)
    if value.respond_to?(:to_i)
      @unit = value.to_i
    else
      raise TypeError, "Can't set a Duration's unit to a #{value.class.name} object."
    end
  end
  def -(value)
    if value.respond_to?(:to_i)
      auto_class(Duration.new(@length - value.to_i))
    else
      raise TypeError, "Can't convert #{value.class.name} to an integer."
    end
  end
  def +(value)
    if value.respond_to?(:to_i)
      auto_class(Duration.new(@length + value.to_i))
    else
      raise TypeError, "Can't convert #{value.class.name} to an integer."
    end
  end
  def *(value)
    if value.is_a?(Duration)
      @length * value.length * value.unit
    elsif value.respond_to?(:to_i)
      auto_class(Duration.new(@length * value))
    else
      raise TypeError, "Can't convert #{value.class.name} to an integer."
    end
  end
  def /(value)
    if value.is_a?(Duration)
      @length / (value.length * value.unit)
    elsif value.respond_to?(:to_i)
      auto_class(Duration.new(@length / value))
    else
      raise TypeError, "Can't convert #{value.class.name} to an integer."
    end
  end
  def in_weeks
    self.unit = Week.length
    auto_class(self)
  end
  def in_days
    self.unit = Day.length
    auto_class(self)
  end
  def in_hours
    self.unit = Hour.length
    auto_class(self)
  end
  def in_minutes
    self.unit = Minute.length
    auto_class(self)
  end
  def in_seconds
    self.unit = Second.length
    auto_class(self)
  end
  def weeks
    @length.to_f / Week.length
  end
  def days
    @length.to_f / Day.length
  end
  def hours
    @length.to_f / Hour.length
  end
  def minutes
    @length.to_f / Minute.length
  end
  def seconds
    @length.to_f / Second.length
  end
  # * * * * * * * * * * * * * * * * * * * * *

  # * * * * * * * * * * * * * * * * * * * * * * *
  # A Duration can be 'anchored' to a START_TIME
  #   -This start_time is a Time object
  def start_time=(value)
    if value.is_a?(Time) || value.is_a?(DateTime)
      @start_time = value.to_time
    else
      raise TypeError, "A Duration's start_time must be a Time or DateTime object."
    end
  end
  def end_time=(value)
    if value.is_a?(Time) || value.is_a?(DateTime)
      @start_time = value.to_time - self #Subtracts this duration from the end_time to get the start_time
    else
      raise TypeError, "A Duration's end_time must be a Time or DateTime object."
    end
  end
  def end_time
    @start_time + self
  end
  def anchored?
    !self.start_time.nil?
  end
  # * * * * * * * * * * * * * * * * * * * * * * *

  # * * * * * * * * * * * * * * * * * * * * * * * *
  # Calculations using Duration as an intermediate
  def from(time)
    time + @length
  end
  def before(time)
    time - @length
  end
  def from_now
    self.from(Time.now)
  end
  def ago
    self.before(Time.now)
  end
  def starting(time)
    self.start_time = time
    self
  end
  def ending(time)
    self.end_time = time
    self
  end
  # * * * * * * * * * * * * * * * * * * * * * * * *

  # * * * * * * * * * * * * * * * * * * * * * * * * * * *
  # A Duration can be treated as a 'collection' of units
  def each_week(&block)
    self.each(Week.length,&block)
  end
  def each_day(&block)
    self.each(Day.length,&block)
  end
  def each_hour(&block)
    self.each(Hour.length,&block)
  end
  def each_minute(&block)
    self.each(Minute.length,&block)
  end
  def each_second(&block)
    self.each(Second.length,&block)
  end
  def collect(use_unit=self.class.length,&block)
    ary = []
    self.each(use_unit) do |x|
      ary << (block_given? ? yield(x) : x)
    end
    ary
  end
  def each(use_unit=self.class.length)
    remainder = @length.to_f % use_unit
    ret = []
    if self.start_time.nil?
      (@length.to_f / use_unit).to_i.times do |i|
        ret << Duration.new(1, use_unit)
        yield(ret[-1])
      end
    else
      (@length.to_f / use_unit).to_i.times do |i|
        ret << Duration.new(1, use_unit, (self.start_time + (use_unit * i)))
        yield(ret[-1])
      end
    end
    if remainder > 0
      ret << (self.start_time.nil? ? Duration.new(remainder, 1) : Duration.new(remainder, 1, (self.start_time + @length - remainder)))
      yield(ret[-1])
    end
    ret
  end
  # * * * * * * * * * * * * * * * * * * * * * * * * * * *

  # * * * * * * * * * * * * * * * * * * * * * * * * * * *
  # Through some ingenious metacoding (see 'def bind_object_method') below,
  # it is possible to create a new method on a Duration object
  # to a method on another object, in order to gather information
  # based on the duration mentioned.
  def create_find_within_method_for(other, method_name, other_method_name)
    self.bind_object_method(other, method_name, other_method_name, [[], ['self.start_time', 'self.end_time']])
  end
  def self.create_find_within_method_for(other, method_name, other_method_name)
    self.bind_class_object_method(other, method_name, other_method_name, [[], ['self.start_time', 'self.end_time']])
  end
  # * * * * * * * * * * * * * * * * * * * * * * * * * * *

  def method_missing(method_name, *args)
    # Delegate any missing methods to the start_time Time object, if we have a start_time and the method exists there.
    return self.start_time.send(method_name, *args) if self.anchored? && self.start_time.respond_to?(method_name)
    super
  end

  private
    def auto_class(obj=self)
      new_obj = case obj.unit
      when 1
        obj.class.name == 'Seconds'  ? obj : (obj.length == 1 ? Second.new(obj.start_time) : Seconds.new(obj.length,obj.start_time))
      when 60
        obj.class.name == 'Minutes'  ? obj : (obj.length == 1 ? Minute.new(obj.start_time) : Minutes.new(obj.length,obj.start_time))
      when 3600
        obj.class.name == 'Hours'    ? obj : (obj.length == 1 ? Hour.new(obj.start_time) : Hours.new(obj.length,obj.start_time))
      when 86400
        obj.class.name == 'Days'     ? obj : (obj.length == 1 ? Day.new(obj.start_time) : Days.new(obj.length,obj.start_time))
      when 604800
        obj.class.name == 'Weeks'    ? obj : (obj.length == 1 ? Week.new(obj.start_time) : Weeks.new(obj.length,obj.start_time))
      else
        obj.class.name == 'Duration' ? obj : Duration.new(obj.length,obj.unit,obj.start_time,{:auto_class => false})
      end
      # Now, auto-transform class if possible:
      case
      when !['Weeks', 'Week'].include?(new_obj.class.name) && new_obj.to_i.remainder(Week.length) == 0
        new_obj.to_i == Week.length ? Week.new(new_obj.start_time) : Weeks.new(new_obj.to_f / Week.length,new_obj.start_time)
      when !['Weeks', 'Week', 'Days', 'Day'].include?(new_obj.class.name) && new_obj.to_i.remainder(Day.length) == 0
        new_obj.to_i == Day.length ? Day.new(new_obj.start_time) : Days.new(new_obj.to_f / Day.length,new_obj.start_time)
      when !['Weeks', 'Week', 'Days', 'Day', 'Hours', 'Hour'].include?(new_obj.class.name) && new_obj.to_i.remainder(Hour.length) == 0
        new_obj.to_i == Hour.length ? Hour.new(new_obj.start_time) : Hours.new(new_obj.to_f / Hour.length,new_obj.start_time)
      when !['Weeks', 'Week', 'Days', 'Day', 'Hours', 'Hour', 'Minutes', 'Minute'].include?(new_obj.class.name) && new_obj.to_f.remainder(Minute.length) == 0
        new_obj.to_i == Minute.length ? Minute.new(new_obj.start_time) : Minutes.new(new_obj.to_f / Minute.length,new_obj.start_time)
      else
        new_obj
      end
    end
end
class Weeks < Duration
  def initialize(count=1,start_time=nil)
    super(count,Week.length,start_time)
  end
  def self.length
    604800
  end
end
class Week < Weeks
  def initialize(start_time=nil)
    super(1,start_time)
  end
end
class Days < Duration
  def initialize(count=1,start_time=nil)
    super(count,Day.length,start_time)
  end
  def self.length
    86400
  end
end
class Day < Days
  def initialize(start_time=nil)
    super(1,start_time)
  end
end
class Hours < Duration
  def initialize(count=1,start_time=nil)
    super(count,Hour.length,start_time)
  end
  def self.length
    3600
  end
end
class Hour < Hours
  def initialize(start_time=nil)
    super(1,start_time)
  end
end
class Minutes < Duration
  def initialize(count=1,start_time=nil)
    super(count,Minute.length,start_time)
  end
  def self.length
    60
  end
end
class Minute < Minutes
  def initialize(start_time=nil)
    super(1,start_time)
  end
end
class Seconds < Duration
  def initialize(count=1,start_time=nil)
    super(count,Second.length,start_time)
  end
  def self.length
    1
  end
end
class Second < Seconds
  def initialize(start_time=nil)
    super(1,start_time)
  end
end

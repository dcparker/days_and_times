require File.dirname(__FILE__) + '/spec_helper.rb'

describe Duration do
  it "should be backward-compatible with previous english time statements" do
    10.minutes.from_now.inspect.should eql((Time.now + 600).inspect)
    3.days.ago.inspect.should eql((Time.now - 3*24*60*60).inspect)
    # More english statements need to be written!!
  end

  it "should store a duration correctly in minutes if told to do so, even when created in seconds" do
    132.seconds.in_minutes.should be_is_a(Minutes)
    132.seconds.in_minutes.unit.should eql(60)
    132.seconds.in_minutes.length.to_s.should eql('2.2')
  end

  it "should add a duration properly to a Time object" do
    (Time.now+1.day).inspect.should eql((Time.now+86400).inspect)
  end

  it "should properly represent time in string, depending on the unit" do
    23.seconds.to_s.should eql("23 Seconds")
  end

  it "should properly perform mathmatical operations, yet considering the unit" do
    (2.days / 2 === 1.day).should eql(true)
    (2.days / 2).in_days.length.should eql(1.day.length)
  end

  it "should automatically map to Day, Minute, Hour, etc if the length matches" do
    (1.week - 6.days).class.name.should eql('Day')
  end

  it "should render durations properly" do
    1.day.should === Duration.new(1, 86400) #=> A duration of 1 day
    7.days.should === Duration.new(7, 86400) #=> A duration of 7 days
    1.week.should === Duration.new(1, 604800) #=> A duration of 1 week
  end
  
  it "should perform mathematics on unanchored durations" do
    (1.week - 2.days).should === Duration.new(5, 86400) #=> A duration of 5 days
  end
  
  it "should perform mathematics on an anchored duration" do
    (3.minutes.ago.until(7.minutes.from(Now())) - 2.minutes).should === Duration.new(8, 60) #=> duration 3 minutes ago to 5 minutes from now
  end

  it "should generate durations from numeric and time arguments" do
    1.week.from(Now()).to_s.should eql((Time.now + 604800).to_s) #=> The time of 1 week from this moment
    1.week.from(Today()).should eql((Time.now + 604800).beginning_of_day) #=> The time of 1 week from the beginning of today
    3.minutes.ago.until(7.minutes.from(Now())).should === Duration.new(10, 60) #=> duration 3 minutes ago to 7 minutes from now
    4.weeks.from(2.days.from(Now())).until(8.weeks.from(Yesterday())) #=> A duration, starting in 4 weeks and 2 days, and ending 8 weeks from yesterday
  end
  
  it "should perform cross-unit calculations" do
    1.week - 1.second #=> A duration of 6 days, 23 hours, 59 minutes, and 59 seconds
  end
  
  it "should perform algebraic calculations respecting the unit" do
    4.weeks / 2 #=> A duration of 2 weeks
    4.weeks / 2.weeks #=> The integer 2
  end
  
  it "should perform iterations respecting the default unit and custom units" do
    8.weeks.each {|week|
      week.should === Duration.new(1, 604800)
    } #=> Runs code for each week contained in the duration (of 8 weeks)
    8.weeks.starting(Now()).each {|week| } #=> Runs code for each week in the duration, but each week is also anchored to a starting time, in sequence through the duration.
    1.week.each {|week| } #=> Automatically chooses week as its iterator
    7.days.each {|day| } #=> Automatically chooses day as its iterator
    1.week.each_day {|day| } #=> Forcing the week to iterate through days
  end

  it "should perform iterations with a remainder that also runs" do
    count = 0
    1.week.each(10.hours.to_f) {|ten_hour_segment|
      count += 1
      ten_hour_segment.should === Duration.new(10, 3600) unless count == 17
    }[-1].should === Duration.new(8, 3600) #=> Using a custom iterator of 10 hours. There would be 17 of them, but notice that the last iteration will only be 8 hours.
  end
end

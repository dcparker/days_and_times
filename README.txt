= days_and_times

* Homepage: http://dcparker.github.com/days_and_times
* Code: http://github.com/dcparker/days_and_times
* Download: http://gemcutter.com/gems/days_and_times

== DESCRIPTION:

Natural language method chaining for Time, Durations and the like.

== FEATURES:

* Singular and plural of the concrete time units (second, minute, hour, day, week) are added to the Numeric object.
* Use the Duration class to do lots of cool things.
* Perform mathematical operations between numbers and durations, durations and durations, and durations and numbers, and the 'unit' will be respected as expected in the algebraic rules.
* Iterate over Duration objects, by the time-unit the duration was instantiated with, or a unit of choice.
* Durations can be 'anchored' to a begin or end time.

== PROBLEMS:

* Months are variable and do not lend themselves to concrete mathematics, so as of now they are not implemented.

== SYNOPSIS:

  1.day #=> A duration of 1 day
  7.days #=> A duration of 7 days
  1.week #=> A duration of 1 week
  1.week - 2.days #=> A duration of 5 days
  1.week.from(Now()) #=> The time of 1 week from this moment
  1.week.from(Today()) #=> The time of 1 week from the beginning of today
  3.minutes.ago.until(7.minutes.from(Now())) #=> duration 3 minutes ago to 7 minutes from now
  3.minutes.ago.until(7.minutes.from(Now())) - 2.minutes #=> duration 3 minutes ago to 5 minutes from now
  4.weeks.from(2.days.from(Now())).until(8.weeks.from(Yesterday())) #=> A duration, starting in 4 weeks and 2 days, and ending 8 weeks from yesterday
  1.week - 1.second #=> A duration of 6 days, 23 hours, 59 minutes, and 59 seconds
  4.weeks / 2 #=> A duration of 2 weeks
  4.weeks / 2.weeks #=> The integer 2
  8.weeks.each {|week| ...} #=> Runs code for each week contained in the duration (of 8 weeks)
  8.weeks.starting(Now()).each {|week| ...} #=> Runs code for each week in the duration, but each week is also anchored to a starting time, in sequence through the duration.
  1.week.each {|week| ...} #=> Automatically chooses week as its iterator
  7.days.each {|day| ...} #=> Automatically chooses day as its iterator
  1.week.each_day {|day| ...} #=> Forcing the week to iterate through days
  1.week.each(10.hours) {|ten_hour_segment| ...} #=> Using a custom iterator of 10 hours. There would be 17 of them, but notice that the last iteration will only be 8 hours.
  # ... and more!

== INSTALL:

  gem install days_and_times -s http://gemcutter.com

== LICENSE:

(The MIT License)

Copyright (c) 2008 BehindLogic

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

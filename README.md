# Ical Importer

Easily import your iCal feeds.

[![TravisCI](https://secure.travis-ci.org/tstmedia/ical_importer.png "TravisCI")](http://travis-ci.org/tstmedia/ical_importer "Travis-CI IcalImporter")

[RubyGems](http://rubygems.org/gems/ical_importer)

# Usage

Add

```ruby
gem 'ical_importer'
```

to your Gemfile

Then you can do:

```ruby
IcalImporter::Parser.new(a_url).parse # To get just an array of events

# To get just an array of events, with a longer timeout [default is 8 sec]
IcalImporter::Parser.new(a_url, :timeout => 40).parse

IcalImporter::Parser.new(a_url).parse do |event|
  event.uid
  event.title
  event.description
  event.location
  event.start_date_time
  event.end_date_time
  event.utc
  event.date_exclusions
  event.recur_end_date
  event.recur_month_repeat_by
  event.recur_interval
  event.recur_interval_value
  event.recurrence_id
  event.all_day_event
  event.recurrence
  event.utc?
  event.all_day_event?
  event.recurrence?
  event.recur_week_sunday
  event.recur_week_monday
  event.recur_week_tuesday
  event.recur_week_wednesday
  event.recur_week_thursday
  event.recur_week_friday
  event.recur_week_saturday
end

parser = IcalImporter::Parser.new(a_url)
parser.parse do |e|
  # block stuffs
end

# Each of these also accepts blocks and returns a list
# MUST parse before using these
parser.all_events
parser.recurrence_events
parser.single_events
```

# Notes

* Recurrence events are not the same as recurring events

# TODO

* Current implementation based on an extraction from another app
  - some of the recurring/recurrence/single logic is fragmented
  - Re-implement to be more similarly classifiable across these different scenarios
* Document Methods

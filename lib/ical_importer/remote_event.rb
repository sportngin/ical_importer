module IcalImporter
  class RemoteEvent
    attr_accessor :event, :utc
    alias :utc? :utc
    delegate :uid, :summary, :location, :recurrence_id, :description, :recurs?, :rrule_property, :exdate, :to => :event

    def initialize(event)
      @event = event
      begin
        @utc = @event.dtstart.try(:tzid) != :floating
      rescue
        @utc = true
      end
    end

    def start_date_time
      get_date_time_for :dtstart
    end

    def end_date_time
      get_date_time_for :dtend
    end

    def all_day_event?
      begin
        (Time.parse(end_date_time.to_s) - Time.parse(start_date_time.to_s)) >= 1.day
      rescue ArgumentError => e # no time info in '', Defaulting to false
        false
      end
    end

    def event_attributes
      {
        :uid => uid,
        :title => summary,
        :utc => utc?,
        :description => description,
        :location => location || '',
        :start_date_time => start_date_time,
        :end_date_time => end_date_time,
        :all_day_event => all_day_event?
      }
    end

    private

    def get_date_time_for(event_method)
      event_method = event_method.to_sym
      raise ArgumentError, "Should be dtend or dtstart" unless [:dtstart, :dtend].include? event_method
      event_time = event.send event_method
      if event_time.is_a? DateTime
        (event_time.tzid == :floating) ? event_time : event_time.utc
      else
        begin
          event_time.to_datetime
        rescue
          event_time
        end
      end
    end
  end
end

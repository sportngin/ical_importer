module IcalImporter
  class RecurrenceEventBuilder
    attr_reader :events_to_build, :built_events
    def initialize
      @events_to_build = []
      @built_events = []
    end

    def <<(event)
      raise ArgumentError, "Must be a RiCal Event" unless event.is_a? RiCal::Component::Event
      @events_to_build << event
    end

    def build
      self.tap do
        events_to_build.each do |remote_event|
          @built_events << build_new_local_event(remote_event)
        end
      end
    end

    private

    def build_new_local_event(remote_event)
      remote_event = RemoteEvent.new remote_event
      LocalEvent.new({
        :uid => remote_event.uid,
        :title => remote_event.summary,
        :description => remote_event.description,
        :location => remote_event.location || '',
        :start_date_time => remote_event.start_date_time,
        :end_date_time => remote_event.end_date_time,
        :date_exclusions => [DateExclusion.new(remote_event.recurrence_id)],
        :recurrence_id => remote_event.recurrence_id,
        :recurrence => true
      })
    end
  end
end

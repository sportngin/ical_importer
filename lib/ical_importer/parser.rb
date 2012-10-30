module IcalImporter
  class Parser
    attr_reader :feed, :bare_feed, :url, :timezone
    attr_accessor :timeout

    DEFAULT_TIMEOUT = 8

    # Get a new Parser object
    #
    # url     - URL where we download the ical feed
    # options - Options hash
    #         :timeout  - Custom timeout for downloading ical feed [Default: 8]
    def initialize(url, options={})
      @url = url
      @timeout = options[:timeout] || DEFAULT_TIMEOUT
      @bare_feed = open_ical
      if should_parse?
        @bare_feed.pos = 0
        begin
          @feed = RiCal.parse @bare_feed
        rescue Exception => e
          # I know, I'm dirty, fix this to log to a config'd log
        end
      end
      @timezone = get_timezone
    end

    def should_parse?
      bare_feed.present?
    end

    def worth_parsing?
      should_parse? && feed.present? && feed.first.present?
    end

    def all_events(&block)
      tap_and_each (@imported_single_events || []) + (@imported_recurrence_events || []), &block
    end

    def single_events(&block)
      tap_and_each (@imported_single_events || []), &block
    end

    def recurrence_events(&block)
      tap_and_each (@imported_recurrence_events || []), &block
    end

    def parse(&block)
      if worth_parsing?
        collected = Collector.new(feed.first.events).collect
        @imported_single_events = collected.single_events
        @imported_recurrence_events = collected.recurrence_events
        tap_and_each (@imported_single_events + @imported_recurrence_events), &block
      end
    end

    private

    def get_timezone
      if feed.present? && feed.first.x_properties["X-WR-TIMEZONE"].present?
        feed.first.x_properties["X-WR-TIMEZONE"].first.value
      end
    end

    def tap_and_each(list)
      list.tap do |r|
        r.each do |event|
          yield event if block_given?
        end
      end
    end

    def open_ical(protocol = 'http')
      raise ArgumentError, "Must be http or https" unless %w[http https].include? protocol
      begin
        ::Timeout::timeout(@timeout) do
          open prepped_uri(protocol)
        end
      rescue
        return open_ical 'https' if protocol == 'http'
        nil
      end
    end

    def prepped_uri(protocol)
      uri = url.strip.gsub(/^[Ww]ebcal:/, "#{protocol}:")
      uri = begin
              URI.unescape(uri)
            rescue URI::InvalidURIError
            end
      URI.escape(uri)
    end

  end
end

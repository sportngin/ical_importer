require 'spec_helper'
module IcalImporter
  describe RecurrenceEventBuilder do
    describe "#initialize" do
      it "should set up basic accessors" do
        subject.events_to_build.should == []
        subject.built_events.should == []
      end
    end

    describe "#<<" do
      it "adds event" do
        new_event = stub(:is_a? => true)
        subject << new_event
        subject.events_to_build.should == [new_event]
      end

      it "fails with incorrect event type" do
        new_event = stub(:is_a? => false)
        expect { subject.<<(new_event) }.to raise_error(ArgumentError, "Must be a RiCal Event")
      end
    end

    describe "#build" do
      it "wraps builds the events and fills in the attribute" do
        event_list = [stub, stub]
        RemoteEvent.stub(:new).and_return(event_list[0], event_list[1])
        subject.stub :events_to_build => event_list
        subject.should_receive(:build_new_local_event).with(event_list[0]).ordered.and_return("boom1")
        subject.should_receive(:build_new_local_event).with(event_list[1]).ordered.and_return("boom2")
        subject.build
        subject.built_events.should == %w[boom1 boom2]
      end
    end

    describe "#build_new_local_event" do
      let(:remote_event) { stub :summary => "birthdayy",
                           :uid => 1,
                           :description => "do stuff",
                           :location => "here",
                           :start_date_time => "today",
                           :end_date_time => "tomorrow",
                           :recurrence_id => 1
      }
      it "creates a new event" do
        RemoteEvent.stub(:new => remote_event)
        local_event = subject.send(:build_new_local_event, remote_event)
        local_event.title.should == "birthdayy"
        local_event.description.should == "do stuff"
        local_event.location.should == "here"
        local_event.start_date_time.should == "today"
        local_event.end_date_time.should == "tomorrow"
        local_event.recurrence.should == true
      end
    end
  end
end

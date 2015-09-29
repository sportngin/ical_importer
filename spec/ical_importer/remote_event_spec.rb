require 'spec_helper'
module IcalImporter
  describe RemoteEvent do
    subject { RemoteEvent.new(event) }
    let(:event) { stub :dtstart => stub(:tzid => nil) }
    it { should respond_to :description }
    it { should respond_to :recurs? }
    it { should respond_to :rrule_property }
    it { should respond_to :exdate }
    describe "#initialize" do
      describe "dtstart tzid nil" do
        it "sets utc and event" do
          subject.event.should == event
          subject.utc?.should == true
        end
      end

      describe "dtstart tzid == :floating" do
        let(:event) { stub :dtstart => stub(:tzid => :floating) }
        it "sets utc and event" do
          subject.event.should == event
          subject.utc?.should == false
        end
      end
    end

    describe "#start_date_time" do
      describe "with string date" do
        let(:event) { stub :dtstart => "20120715" }
        it "gets the date time" do
          subject.start_date_time.should == event.dtstart.to_datetime
        end
      end

      describe "with an actual DateTime" do
        let(:event) { stub :dtstart => "20120715".to_datetime }
        it "uses the datetime because it is already that" do
          subject.start_date_time.should == event.dtstart
        end
      end

      describe "without a floating tzid" do
        let(:event) { stub :dtstart => stub(
          :is_a? => true,
          :tzid => nil,
          :time => "20120715".to_datetime,
          :utc => "20120715".to_datetime.utc) }
        it "uses the utc time of the datetime" do
          subject.start_date_time.should == event.dtstart.time.utc
        end
      end
    end

    describe "#event_attributes" do
      let(:event) { RiCal.parse(sample_ics).first.events.first }
      it "fills in some attributes" do
        subject.event_attributes.should == {
          :uid => "1629F7A5-5A69-43CB-899E-4CE9BD5F069F",
          :title => "Recurring Event",
          :utc => true,
          :description => nil,
          :location => "",
          :start_date_time => "Wed, 14 Sep 2016 00:00:00 +0000".to_datetime,
          :end_date_time => "Thu, 15 Sep 2016 00:00:00 +0000".to_datetime,
          :all_day_event => true}
      end
    end
  end
end

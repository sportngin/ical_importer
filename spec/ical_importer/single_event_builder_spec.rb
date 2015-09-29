require 'spec_helper'
module IcalImporter
  describe SingleEventBuilder do
    subject { SingleEventBuilder.new(event) }
    let(:event) { Icalendar.parse(sample_ics('mn_twins')).first.events.first }
    describe "#build" do
      it "builds an event" do
        new_event = subject.build
        new_event.should be_a LocalEvent
        new_event.title.should == "Spring Training: Tampa Bay 3 - Minnesota 7"
        new_event.utc?.should == true
        new_event.description.should == ["Spring Training: Tampa Bay 3 - Minnesota 7\n\nClick below for game previews", " wraps and boxscores plus video", " tickets", " stats", " gameday and more!\nhttp://mlb.mlb.com/mlb/gameday/index.jsp?gid=2012_03_03_tbamlb_minmlb_1\n\nWatch or Listen with MLB.TV: http://mlb.mlb.com/schedule/index.jsp?c_id=min&m=03&y=2012\n\nLocal Radio: 1500 ESPN"]
        new_event.location.should ==  ["Lee County Sports Complex", " Hammond County Stadium", " Lee County"]
        new_event.all_day_event.should == false
      end
    end
  end
end

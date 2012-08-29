require 'spec_helper'
module IcalImporter
  describe DateExclusion do
    subject { DateExclusion.new(date) }
    describe "#initialize" do
      describe "set the one valid attribute" do
        let(:date) {  "yerp" }
        it "sets the date exlcusion" do
          subject.date_exclusion.should == "yerp"
        end
      end

      describe "try to set valid/invalid attributes" do
        let(:date) { "yerp" }
        it "sets the date exlcusion" do
          subject.date_exclusion.should == "yerp"
          expect { subject.not_me }.to raise_error(NoMethodError)
        end
      end
    end
  end
end

require 'rails_helper'

RSpec.describe Timespans::Timespan, type: :model, dbclean: :after_each do

  let(:this_year)	{ Date.today.year }
  let(:begin_on)	{ Date.new(this_year, 1, 1) }
  let(:end_on)		{ Date.new(this_year, 12, 31) }
  let(:title)		{ this_year.to_s }

  let(:params) do
    {
      title:	title,
      begin_on:	begin_on,
      end_on:	end_on,
    }
  end

  context "A new Timespan instance" do
  end

  describe "class methods" do
    context ".find_on" do
      let(:next_year)         { Date.today.year + 1 }
      let(:next_begin_on)     { Date.new(next_year, 1, 1) }
      let(:next_end_on)       { Date.new(next_year, 12, 31) }
      # let!(:match_period)       { described_class.create!(title: "match_period", begin_on: begin_on, end_on: end_on) }
      # let!(:next_match_period)  { described_class.create!(title: "next_match_period", begin_on: next_begin_on, end_on: next_end_on) }

      context "seeded timespan collection" do

        it "the collection should be loaded" do
          expect(described_class.all.size).to be > 1
        end

        context "and a date with a matching record in the collection" do

          it "should find each period by matching passed date" do
            expect( described_class.find_on(next_begin_on).entries).to eq [next_begin_on]
          end
        end

        context "and a date with no matching record in the collection"

        it "should return nil for non-matching date", :aggregate_failures do
          expect(described_class.find_on(match_period.begin_on - 1.day)).to eq []
        end
      end

    end
  end


  describe "instance methods" do
    context "#to_range" do
      subject { described_class.new(params) }

      it "should output to range type" do
        expect(subject.to_range).to eq begin_on..end_on
      end
    end

    context "#between?" do
      let(:before_period) { begin_on - 1.day }
      let(:after_period)  { end_on + 1.day }
      let(:during_period) { begin_on + 1.day }

      subject { described_class.new(params) }

      it "before_period should be false" do
        expect(subject.between?(before_period)).to eq false
      end

      it "after_period should be false" do
        expect(subject.between?(after_period)).to eq false
      end

      it "during_period should be true" do
        expect(subject.between?(during_period)).to eq true
      end

      it "begin_on should be true" do
        expect(subject.between?(begin_on)).to eq true
      end

      it "end_on should be true" do
        expect(subject.between?(end_on)).to eq true
      end
    end

  end

end

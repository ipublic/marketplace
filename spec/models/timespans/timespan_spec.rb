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

  describe "instance methods" do
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

    context "#to_range" do
      subject { described_class.new(params) }

      it "should output to range type" do
        expect(subject.to_range).to eq begin_on..end_on
      end
    end

  end

end

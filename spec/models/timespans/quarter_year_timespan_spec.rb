require 'rails_helper'

RSpec.describe Timespans::QuarterYearTimespan, type: :model do

	let(:year)							{ Date.today.year }
	let(:quarter)						{ 1 }
	let(:quarter_too_large)	{ 5 }
	let(:quarter_too_small) { 0 }
	let(:year_too_large)		{ Timespans::YEAR_MAXIMUM + 1 }
	let(:year_too_small) 		{ Timespans::YEAR_MINIMUM - 1 }

  let(:params) do
    {
    	year:			year,
      quarter:	quarter,
    }
  end

  describe "A new model instance" do
   	it { is_expected.to be_mongoid_document }
			it { is_expected.to have_timestamps }
    it { is_expected.to have_fields(:year, :quarter)}

    context "with no arguments" do
      subject { described_class.new }

      it "should not be valid" do
        subject.validate
        expect(subject).to_not be_valid
      end
    end

    context "with no year" do
      subject { described_class.new(params.except(:year)) }

      it "should not be valid" do
        subject.validate
        expect(subject).to_not be_valid
        expect(subject.errors[:year].first).to match(/can't be blank/)
      end
    end

    context "with no quarter" do
      subject { described_class.new(params.except(:quarter)) }

      it "should not be valid" do
        subject.validate
        expect(subject).to_not be_valid
        expect(subject.errors[:quarter].first).to match(/can't be blank/)
      end
    end

    context "with invalid quarter values" do
      subject { described_class.new(year: year, quarter: quarter_too_large) }

      it "should not be valid" do
        subject.validate
        expect(subject).to_not be_valid
        expect(subject.errors[:quarter]).to_not be_nil 
        expect(subject.errors[:year]).to be_blank
      end

      subject { described_class.new(year: year, quarter: quarter_too_small) }

      it "should not be valid" do
        subject.validate
        expect(subject).to_not be_valid
        expect(subject.errors[:quarter]).to_not be_nil 
        expect(subject.errors[:year]).to be_blank
      end
    end

    context "with all required arguments" do
      subject {described_class.new(params) }

      it "should be valid" do
        subject.validate
        expect(subject).to be_valid
      end

      it "should compose a correct title" do
        subject.validate
      	expect(subject.title).to eq "#{year} Q#{quarter}"
      end

      context "and it is saved" do

        it "should save" do
          expect(subject.save).to eq true
        end

        context "it should be findable" do
          before { subject.save! }
          it "should return the instance" do
            expect(described_class.find(subject.id.to_s)).to eq subject
          end
        end
      end
    end
  end


end

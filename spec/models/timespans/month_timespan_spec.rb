require 'rails_helper'

RSpec.describe Timespans::MonthTimespan, type: :model do
	let(:year)							       	{ Date.today.year }
	let(:month)                    	{ 6 }
	let(:abbrev_month)							{ Date::ABBR_MONTHNAMES[month] }
	let(:month_too_large)          	{ 13 }
	let(:month_too_small)          	{ 0 }
  let(:calendar_year_timespan)   	{ FactoryBot.build(:timespans_calendar_year_timespan) }

  let(:params) do
    {
      calendar_year_timespan: calendar_year_timespan,
    	year:			year,
      month:    month,
    }
  end

  describe "A new model instance" do
   	it { is_expected.to be_mongoid_document }
		it { is_expected.to have_timestamps }
    it { is_expected.to have_fields(:year, :month)}

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

    context "with no month" do
      subject { described_class.new(params.except(:month)) }

      it "should not be valid" do
        subject.validate
        expect(subject).to_not be_valid
        expect(subject.errors[:month].first).to match(/can't be blank/)
      end
    end

    # context "with invalid month values" do
    #   subject { described_class.new(year: year, month: month_too_large) }

    #   it "should not be valid" do
    #     subject.validate
    #     expect(subject).to_not be_valid
    #     expect(subject.errors[:month]).to_not be_nil 
    #     expect(subject.errors[:year]).to be_blank
    #   end

    #   subject { described_class.new(year: year, month: month_too_small) }

    #   it "should not be valid" do
    #     subject.validate
    #     expect(subject).to_not be_valid
    #     expect(subject.errors[:month]).to_not be_nil 
    #     expect(subject.errors[:year]).to be_blank
    #   end
    # end

    context "with all required arguments" do
      subject {described_class.new(params) }

      it "should be valid" do
        subject.validate
        expect(subject).to be_valid
      end

      it "should compose a correct title" do
        subject.validate
      	expect(subject.title).to eq "#{year} #{abbrev_month}"
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

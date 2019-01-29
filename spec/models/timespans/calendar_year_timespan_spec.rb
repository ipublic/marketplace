require 'rails_helper'

module Timespans
	RSpec.describe CalendarYearTimespan, type: :model, dbclean: :after_each do

	  let(:year)							{ TimeKeeper.date_of_record.year }
	  let(:year_too_large)		{ Timespans::YEAR_MAXIMUM + 1 }
	  let(:year_too_small) 		{ Timespans::YEAR_MINIMUM - 1 }

	  let(:params) do
	    {
	      year:	year,
	    }
	  end

	  describe "A new model instance" do
	    it { is_expected.to be_mongoid_document }
	    it { is_expected.to have_timestamps }
	    it { is_expected.to have_fields(:year) }
	    it { should validate_numericality_of(:year).greater_than_or_equal_to(YEAR_MINIMUM).less_than_or_equal_to(YEAR_MAXIMUM) }

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

	    context "with invalid year values" do
	      subject { described_class.new(year: year_too_large) }

	      it "should not be valid" do
	        subject.validate
	        expect(subject).to_not be_valid
	        expect(subject.errors[:year]).to_not be_nil
	      end

	      subject { described_class.new(year: year_too_small) }

	      it "should not be valid" do
	        subject.validate
	        expect(subject).to_not be_valid
	        expect(subject.errors[:year]).to_not be_nil
	      end
	    end

	    context "with all required arguments" do
	      subject {described_class.new(params) }

	      it "should compose a correct title" do
	        subject.validate
	        expect(subject.title).to eq "#{year}"
	      end

	    	it "should create quarter year instances" do
	    		subject.validate
	    		expect(subject.quarter_year_timespans.size).to eq 4
	    	end

	    	it "should create month instances" do
	    		subject.validate
	    		expect(subject.month_timespans.size).to eq 12
	    	end

	      it "should be valid" do
	        subject.validate
	        expect(subject).to be_valid
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

	  describe "Class methods" do

	    context ".find_on" do
	      let(:next_year)         		{ year + 1 }
	      let(:next_begin_on)     		{ Date.new(next_year, 1, 1) }
	      let(:next_end_on)       		{ Date.new(next_year, 12, 31) }
	      let!(:match_timespan)       { described_class.create!(year: year) }
	      let!(:next_match_timespan)  { described_class.create!(year: next_year) }

	      context "seeded timespan collection" do

	        it "the collection should be loaded" do
	          expect(described_class.all.size).to be > 1
	        end

	        context "and a date with a matching record in the collection" do

	          it "should find timespan covered by date argument" do
	            expect( described_class.find_on(next_begin_on).entries.first.begin_on).to eq next_begin_on
	          end
	        end

	        context "and a date with no matching record in the collection"

	        it "should return nil for non-matching date", :aggregate_failures do
	          expect(described_class.find_on(match_timespan.begin_on - 1.day)).to eq []
	        end
	      end

	    end
	  end

	  describe "Instance methods" do
	  end
  
	end
end
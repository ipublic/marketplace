require 'rails_helper'

module Wages
	RSpec.describe WageReport, type: :model, dbclean: :after_each do

    it { is_expected.to be_mongoid_document }
    it { is_expected.to have_timestamps }
    it { is_expected.to belong_to(:organization_party)}
    it { is_expected.to embed_many(:wage_entries)}
    it { is_expected.to belong_to(:timespan)}

    let(:organization_party)  { Parties::OrganizationParty.new() }
    let(:timespan)            { Timespans::CalendarYearTimespan.new(year: TimeKeeper.date_of_record.year) }
    let(:wage_entries)        { Wages::WageEntry.new().to_a }
    let(:submission_kind)     { :original }
    let(:filing_method_kind)  { :upload }
    let(:state_total_gross_wages) { 60_101.54 }
    let(:total_wages)         { 40_125.32 }
		let(:excess_wages)        {  5_125.11 }
		let(:taxable_wages)       { total_wages - excess_wages }

    let(:params) do
      {
        organization_party:         organization_party,
        timespan:                   timespan,
        wage_entries:               wage_entries,
        submission_kind:            submission_kind,
        filing_method_kind:         filing_method_kind,
        state_total_gross_wages:		state_total_gross_wages,
      }
    end

    describe "A new model instance" do

      context "with no arguments" do
        subject { described_class.new }

        it "should not be valid" do
          subject.validate
          expect(subject).to_not be_valid
        end
      end

      context "with no state_total_gross_wages" do
        subject { described_class.new(params.except(:state_total_gross_wages)) }

        it "should not be valid" do
          subject.validate
          expect(subject).to_not be_valid
          expect(subject.errors[:state_total_gross_wages].first).to match(/can't be blank/)
        end
      end

      context "with no filing_method_kind" do
        subject { described_class.new(params.except(:filing_method_kind)) }

        it "should not be valid" do
          subject.validate
          expect(subject).to_not be_valid
          expect(subject.errors[:filing_method_kind].first).to match(/can't be blank/)
        end
      end

      context "with no submission_kind" do
        subject { described_class.new(params.except(:submission_kind)) }

        it "should not be valid" do
          subject.validate
          expect(subject).to_not be_valid
          expect(subject.errors[:submission_kind].first).to match(/can't be blank/)
        end
      end

      context "with no organization_party" do
        subject { described_class.new(params.except(:organization_party)) }

        it "should not be valid" do
          subject.validate
          expect(subject).to_not be_valid
          expect(subject.errors[:organization_party].first).to match(/can't be blank/)
        end
      end

      context "with all required arguments" do
        subject {described_class.new(params) }

        it "should be valid" do
          subject.validate
          expect(subject).to be_valid
        end

        # context "and it is saved" do

        #   it "should save" do
        #     expect(subject.save).to eq true
        #   end

        #   context "it should be findable" do
        #     before { subject.save! }
        #     it "should return the instance" do
        #       expect(described_class.find(subject.id.to_s)).to eq subject
        #     end
        #   end
        # end
      end
    end
	end
end
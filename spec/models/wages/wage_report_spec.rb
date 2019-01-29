require 'rails_helper'

module Wages
	RSpec.describe WageReport, type: :model, dbclean: :after_each do

    it { is_expected.to be_mongoid_document }
    it { is_expected.to have_timestamps }
    it { is_expected.to belong_to(:organization_party)}
    it { is_expected.to embed_many(:wage_entries)}
    it { is_expected.to have_one(:timespan)}

    let(:organization_party)  { Parties::OrganizationParty.new() }
    let(:timespans)           { Timespans::Timespan.first.to_a }
    let(:wage_entries)        { Wages::WageEntry.new().to_a }
    let(:submission_kind)     { :original }
    let(:filing_method_kind)  { :upload }
		let(:total_wages)         { 40_125.32 }
		let(:excess_wages)        {  5_125.11 }
		let(:taxable_wages)       { total_wages - excess_wages }

    let(:params) do
      {
        organization_party:         organization_party,
        timespans:                  timespans,
        wage_entries:               wage_entries,
        submission_kind:            submission_kind,
        filing_method_kind:         filing_method_kind,
        state_total_gross_wages:		state_total_gross_wages,
        excess_wages:	              excess_wages,
        taxable_wages:	            taxable_wages,
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

      context "with no total_wages" do
        subject { described_class.new(params.except(:total_wages)) }

        it "should not be valid" do
          subject.validate
          expect(subject).to_not be_valid
          expect(subject.errors[:total_wages].first).to match(/can't be blank/)
        end
      end

      context "with no excess_wages" do
        subject { described_class.new(params.except(:excess_wages)) }

        it "should not be valid" do
          subject.validate
          expect(subject).to_not be_valid
          expect(subject.errors[:excess_wages].first).to match(/can't be blank/)
        end
      end

      context "with no taxable_wages" do
        subject { described_class.new(params.except(:taxable_wages)) }

        it "should not be valid" do
          subject.validate
          expect(subject).to_not be_valid
          expect(subject.errors[:taxable_wages].first).to match(/can't be blank/)
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
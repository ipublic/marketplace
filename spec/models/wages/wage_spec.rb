require 'rails_helper'

module Wages
	RSpec.describe Wage, type: :model do

		let(:person_party)								{ Parties::PersonParty.create(current_first_name: "Mary", current_last_name: "Poppins") }
		let(:state_qtr_ui_total_wages)		{ 40_125.32 }
		let(:state_qtr_ui_excess_wages)		{  5_125.11 }
		let(:state_qtr_ui_taxable_wages)	{ state_qtr_ui_total_wages - state_qtr_ui_excess_wages }

    let(:params) do
      {
      	person_party_id: 						person_party._id,
        state_qtr_ui_total_wages:		state_qtr_ui_total_wages,
        state_qtr_ui_excess_wages:	state_qtr_ui_excess_wages,
        state_qtr_ui_taxable_wages:	state_qtr_ui_taxable_wages,
      }
    end

    describe "A new model instance" do
     	it { is_expected.to be_mongoid_document }
 			it { is_expected.to have_timestamps }
      it { is_expected.to have_fields(:person_party_id, :state_qtr_ui_total_wages, :state_qtr_ui_excess_wages, :state_qtr_ui_taxable_wages)}
     	it { is_expected.to be_embedded_in(:wage_report)}

      context "with no arguments" do
        subject { described_class.new }

        it "should not be valid" do
          subject.validate
          expect(subject).to_not be_valid
        end
      end

      context "with no state_qtr_ui_total_wages" do
        subject { described_class.new(params.except(:state_qtr_ui_total_wages)) }

        it "should not be valid" do
          subject.validate
          expect(subject).to_not be_valid
          expect(subject.errors[:state_qtr_ui_total_wages].first).to match(/can't be blank/)
        end
      end

      context "with no state_qtr_ui_excess_wages" do
        subject { described_class.new(params.except(:state_qtr_ui_excess_wages)) }

        it "should not be valid" do
          subject.validate
          expect(subject).to_not be_valid
          expect(subject.errors[:state_qtr_ui_excess_wages].first).to match(/can't be blank/)
        end
      end

      context "with no state_qtr_ui_taxable_wages" do
        subject { described_class.new(params.except(:state_qtr_ui_taxable_wages)) }

        it "should not be valid" do
          subject.validate
          expect(subject).to_not be_valid
          expect(subject.errors[:state_qtr_ui_taxable_wages].first).to match(/can't be blank/)
        end
      end

      context "with no person_party_id" do
        subject { described_class.new(params.except(:person_party_id)) }

        it "should not be valid" do
          subject.validate
          expect(subject).to_not be_valid
          expect(subject.errors[:person_party_id].first).to match(/can't be blank/)
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

    describe "A new Wage without an assgiend PersonParty" do
      let(:wage)     { described_class.new(params.except(:person_party_id)) }

      it "should not have an assigned PersonParty" do
      	expect(wage.person_party_id).to be_nil
      	expect(wage.person_party).to be_nil
      end

      context "and using an existing PersonParty instance" do

        it "should find a PersonParty in database" do
          expect(Parties::PersonParty.find(person_party._id)).to eq person_party
        end

        context "and the PersonParty is assigned to the Wage instance" do

        	it "the assignment should write the PersonParty ID to the Wage attribute" do
        		wage.person_party = person_party
        		expect(wage.person_party_id).to eq person_party.id
        	end

        	it "the getter should return the PersonParty instance" do
        		wage.person_party = person_party
        		expect(wage.person_party).to eq person_party
        	end
        end

      end


    end
	end
end
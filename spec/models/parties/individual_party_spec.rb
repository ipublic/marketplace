require 'rails_helper'

module Parties
	RSpec.describe IndividualParty, type: :model do

		let(:current_first_name)			{ "Mary" }
		let(:current_last_name)				{ "Poppins" }
		let(:mary)										{ Party::IndividualParty.new(current_first_name: current_first_name, current_last_name: current_last_name) }
		let(:party_role)							{ Party::PartyRole.new(role_kind: :employee, start_date: Date.new(2003,1,1)) }

		let(:employment_relationship)	{ Party:PartyRelationship.new(relationship_kind: :organization_contact, related_party: :ideacrew, start_date: Date.new(2003,1,1), thru_date: Date.new(2016,1,1)) }
		let(:contact_relationship)		{ Party:PartyRelationship.new(relationship_kind: :employment, related_party: :ideacrew, start_date: Date.new(2003,1,1)) }


    let(:params) do
      {
          current_first_name:	current_first_name,
          current_last_name:	current_last_name,
      }
    end

    describe "A new model instance" do
     it { is_expected.to be_mongoid_document }
     it { is_expected.to have_fields(:party_id, :current_first_name, :current_last_name)}

     it { is_expected.to embed_many(:party_roles)}
     it { is_expected.to embed_many(:party_relationships)}
     it { is_expected.to embed_many(:determinations)}
     it { is_expected.to have_many(:notices)}
     it { is_expected.to have_many(:accounts)}

      context "with no arguments" do
        subject { described_class.new }

        it "should not be valid" do
          subject.validate
          expect(subject).to_not be_valid
        end
      end

      context "with no current_first_name" do
        subject { described_class.new(params.except(:current_first_name)) }

        it "should not be valid" do
          subject.validate
          expect(subject).to_not be_valid
          expect(subject.errors[:current_first_name].first).to match(/can't be blank/)
        end
      end

      context "with no current_last_name" do
        subject { described_class.new(params.except(:current_last_name)) }

        it "should not be valid" do
          subject.validate
          expect(subject).to_not be_valid
          expect(subject.errors[:current_last_name].first).to match(/can't be blank/)
        end
      end

      context "with all required arguments" do
        subject {described_class.new(params) }

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
  end

end

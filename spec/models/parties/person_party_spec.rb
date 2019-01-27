require 'rails_helper'

module Parties
	RSpec.describe PersonParty, type: :model do

		let(:current_first_name)			{ "Mary" }
		let(:current_last_name)				{ "Poppins" }
		let(:mary)										{ Party::PersonParty.new(current_first_name: current_first_name, current_last_name: current_last_name) }

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

    describe "Managing PartyRoles" do
    	let(:employee_party_role_kind)	{ Parties::PartyRoleKind.create(kind: :employee, title: "Employee", is_published: true)}
			let(:employee_party_role)				{ Parties::PartyRole.new(kind: employee_party_role_kind, start_date: Date.new(2003,1,1)) }

			context "An Individual without any PartyRoles" do
				let(:individual_party)     { described_class.new(params) }

	      it "should have no PartyRoles" do
	      	expect(individual_party.party_roles).to eq []
	      end

	    	context "and a PartyRole is added" do

	    		it "should have the new PartyRole" do
		    		individual_party.add_party_role(employee_party_role)
		    		expect(individual_party.party_roles.size).to eq 1
		    		expect(individual_party.party_roles.first).to eq employee_party_role
	    		end
	    	end
	    end
    end

    describe "Managing PartyRelationships" do
    	let(:fein)																{ "987654321" }
    	let(:legal_name)													{ "ACME Widgets, Inc." }
   		let(:organization_party)			{ Parties::OrganizationParty.new(fein: fein, legal_name: legal_name) }

    	let(:employment_party_relationship_kind)	{ Parties::PartyRelationshipKind.new() }
    	let(:contact_party_relationship_kind)			{ Parties::PartyRelationshipKind.new() }

			let(:employment_relationship)	{ Parties::PartyRelationship.new(kind: :employment, related_party: :organization_party, start_date: Date.new(2003,1,1), thru_date: Date.new(2016,1,1)) }
			let(:contact_relationship)		{ Parties::PartyRelationship.new(kind: :organization_contact, related_party: :organization_party, start_date: Date.new(2003,1,1)) }


			context "An Individual without any PartyRelationships" do
 				let(:individual_party)     { described_class.new(params) }

	      it "should have no PartyRelationships" do
	      	expect(individual_party.party_relationships).to eq []
	      end

	    	context "and a PartyRelationship is added" do

	    		it "should have the new PartyRelationship" do
		    		individual_party.add_party_relationship(employment_relationship)
		    		expect(subject.party_relationships.size).to eq 1
		    		expect(subject.party_relationships.first).to eq employment_relationship
	    		end
	    	end

			end

    end

  end
end

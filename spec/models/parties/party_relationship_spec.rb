require 'rails_helper'

RSpec.describe Parties::PartyRelationship, type: :model, dbclean: :after_each do
    it { is_expected.to be_mongoid_document }
		it { is_expected.to have_timestamps }

    it { is_expected.to belong_to(:party_relationship_kind)}
    it { is_expected.to have_many(:party_roles)}

    it { is_expected.to have_fields(:start_date, :end_date)}

    let(:title)													{ party_relationship_kind.title }
    let(:key)														{ party_relationship_kind.key }

    let(:hero_party_role_kind)					{ Parties::PartyRoleKind.create!(key: :hero) }
    let(:evil_ex_party_role_kind)				{ Parties::PartyRoleKind.create!(key: :evil_ex) }
    let(:party_role_kinds)							{ [hero_party_role_kind, evil_ex_party_role_kind] }

    let(:hero_party_role)								{ Parties::PartyRole.new(party_role_kind: hero_party_role_kind) }
    let(:evil_ex_party_role)						{ Parties::PartyRole.new(party_role_kind: evil_ex_party_role_kind) }

    let(:party_relationship_kind_key) 	{ :battle_opponents }
    let(:party_relationship_kind)				{ Parties::PartyRelationshipKind.create!(key: party_relationship_kind_key, party_role_kinds: party_role_kinds) }

    let(:scott_pilgrim_person_party)		{ Parties::PersonParty.new(current_first_name: 'Scott', current_last_name: 'Pilgrim', party_roles: [hero_party_role]) }
    let(:matthew_patel_person_party)		{ Parties::PersonParty.new(current_first_name: 'Matthew', current_last_name: 'Patel', party_roles: [evil_ex_party_role]) }

    let(:scott_pilgrim_party_role)			{ scott_pilgrim_person_party.party_roles.first }
    let(:matthew_patel_party_role)			{ matthew_patel_person_party.party_roles.first }

    let(:party_roles)										{ [scott_pilgrim_party_role, matthew_patel_party_role] }

	  let(:params) do
	    {
	      party_relationship_kind: party_relationship_kind,
	      party_roles: party_roles,
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

      context "with no party_relationship_kind" do
        subject { described_class.new(params.except(:party_relationship_kind)) }

        it "should not be valid" do
          subject.validate
          expect(subject).to_not be_valid
          expect(subject.errors[:party_relationship_kind].first).to match(/can't be blank/)
        end
      end

      context "with no party_roles" do
        subject { described_class.new(params.except(:party_roles)) }

        it "should not be valid" do
          subject.validate
          expect(subject).to_not be_valid
          expect(subject.errors[:party_roles].first).to match(/must provide a specific role pair/)
        end
      end

      context "with all required arguments" do
        subject {described_class.new(params) }

        it "should be valid" do
          subject.validate
          expect(subject).to be_valid
        end

        it "should have access to delegated attributes" do
        	expect(subject.key).to eq key
        	expect(subject.title).to eq title
        end

        it "should be active" do
        	expect(subject.is_active?).to be_truthy 
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

	  describe "Managing PartyRelationships" do
	  end
end

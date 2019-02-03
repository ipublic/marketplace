require 'rails_helper'

RSpec.describe Roles::RoleFactory, type: :model, dbclean: :after_each do


  let(:hero_party_role_kind_key)		{ :hero }
  let(:evil_ex_party_role_kind_key)	{ :evil_ex }

  let(:current_first_name)					{ 'Scott' }
  let(:current_last_name)						{ 'Pilgrim' }

  let(:scott_pilgrim_party)					{ Parties::PersonParty.create!(current_first_name: current_first_name, current_last_name: current_last_name) }
  let!(:hero_party_role_kind)				{ Parties::PartyRoleKind.create!(key: hero_party_role_kind_key) }
  let!(:evil_ex_party_role_kind)			{ Parties::PartyRoleKind.create!(key: evil_ex_party_role_kind_key) }

  describe 'Given a PersonParty with no PartyRoles and some party_role_kinds' do

    it "PartyRoles should be empty" do
      expect(scott_pilgrim_party.party_roles.size).to eq 0
    end

    context 'and a PartyRole is added' do

      it 'the PersonParty should now reference the added PartyRole' do
        factory = Roles::RoleFactory.new(scott_pilgrim_party, hero_party_role_kind_key)
        expect(factory.party_role.party_role_kind).to eq hero_party_role_kind
        expect(scott_pilgrim_party.party_roles.size).to eq 1
        expect(scott_pilgrim_party.party_roles.first.party_role_kind).to eq hero_party_role_kind
        scott_pilgrim_party.validate
        expect(scott_pilgrim_party).to be_valid
      end
    end

    context 'and the same PartyRole is added again' do

      it 'should block addition of the duplicate PartyRole' do
        factory = Roles::RoleFactory.new(scott_pilgrim_party, hero_party_role_kind_key)
        expect(scott_pilgrim_party.party_roles.size).to eq 1
        expect(scott_pilgrim_party.party_roles.first.party_role_kind).to eq hero_party_role_kind

        duplicate_factory = Roles::RoleFactory.new(scott_pilgrim_party, hero_party_role_kind_key)
        expect(duplicate_factory.party_role).to eq nil
      end
    end
  end
end

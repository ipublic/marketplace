require 'rails_helper'

RSpec.describe Roles::RelationshipRoleFactory, type: :model, dbclean: :after_each do

  let(:band_battle_party_relationship_kind_key)	{ :band_battle }

  let(:hero_party_role_kind_key)		{ :hero }
  let(:evil_ex_party_role_kind_key)	{ :evil_ex }

  let(:hero_current_first_name)			{ 'Scott' }
  let(:hero_current_last_name)			{ 'Pilgrim' }

  let(:evil_ex_current_first_name)	{ 'Matthew' }
  let(:evil_ex_current_last_name)		{ 'Patel' }

  let!(:hero_party)									{ Parties::PersonParty.create!(current_first_name: hero_current_first_name, 
  																																	current_last_name: hero_current_last_name) 
																																	}
  let!(:evil_ex_party)								{ Parties::PersonParty.create!(current_first_name: evil_ex_current_first_name, 
  																																	current_last_name: evil_ex_current_last_name) 
																																	}

  let!(:hero_party_role_kind)									{ Parties::PartyRoleKind.create!(key: hero_party_role_kind_key) }
  let!(:bollywood_evil_ex_role_kind)					{ Parties::PartyRoleKind.create!(key: evil_ex_party_role_kind_key) }
  let(:party_role_kinds)											{ [hero_party_role_kind, bollywood_evil_ex_role_kind] }
  let!(:band_battle_party_relationship_kind)	{ Parties::PartyRelationshipKind.create!(key: band_battle_party_relationship_kind_key,
  																																											party_role_kinds: party_role_kinds) 
																																	}

  describe 'Given a two or more PersonParties with no PartyRoles and database seeded with two or more PartyRoleKinds' do

  	it "PartyRelationshipKinds should be available" do
  		expect(Parties::PartyRelationshipKind.all.size).to be > 0
  	end

  	it "PersonParties should be available" do
  		expect(Parties::PersonParty.all.size).to be > 1
  	end

    it "PartyRoles should be empty" do
      expect(hero_party.party_roles.size).to eq 0
      expect(evil_ex_party.party_roles.size).to eq 0
    end

    it "PartyRoleKinds should be available" do
    	expect(Parties::PartyRoleKind.all.size).to be > 1
    end

    context "and a PartyRelationship is added" do
    	before {
    	}

    	it "should produce a valid PartyRelationship" do
	    	factory = Roles::RelationshipRoleFactory.new(hero_party, hero_party_role_kind_key, band_battle_party_relationship_kind_key, evil_ex_party)
	      new_party_relationship = factory.party_relationship
	      expect(new_party_relationship.party_relationship_kind).to eq band_battle_party_relationship_kind
	      expect(new_party_relationship.party_roles.map(&:party_role_kind)).to match_array party_role_kinds
	      new_party_relationship.validate
	      expect(new_party_relationship).to be_valid
    	end
    	
    	it "should assign correct PartyRole for each PersonParty" do
	    	factory = Roles::RelationshipRoleFactory.new(hero_party, hero_party_role_kind_key, band_battle_party_relationship_kind_key, evil_ex_party)
	      expect(factory.party.party_roles.first.party_role_kind).to eq hero_party_role_kind
	      expect(factory.related_party.party_roles.first.party_role_kind).to eq bollywood_evil_ex_role_kind
    	end
    	
    end
  end

   #  let(:bollywood_evil_ex_role)		{ Parties::PartyRoleKind.create!(key: :evil_ex) }
   #  let(:skateboarder_evil_ex_role)	{ Parties::PartyRoleKind.create!(key: :evil_ex) }
   #  let(:vegan_evil_ex_role)				{ Parties::PartyRoleKind.create!(key: :evil_ex) }
   #  let(:exgirlfriend_evil_ex_role)	{ Parties::PartyRoleKind.create!(key: :evil_ex) }
   #  let(:twin_one_evil_ex_role)			{ Parties::PartyRoleKind.create!(key: :evil_ex) }
   #  let(:twin_two_evil_ex_role)			{ Parties::PartyRoleKind.create!(key: :evil_ex) }
   #  let(:gman_evil_ex_role)					{ Parties::PartyRoleKind.create!(key: :evil_ex) }

   #  let(:subject_party_role_kind)		{ Parties::PartyRoleKind.create!(key: :hero) }
   #  let(:object_party_role_kind)		{ Parties::PartyRoleKind.create!(key: :evil_ex) }

   #  let(:party_role_kinds)					{ [subject_party_role_kind, object_party_role_kind] }

  	# let(:dating_partners_party_relationship_kind) { Parties::PartyRelationshipKind.new(key: :dating_partners) }
   #  let(:party_relationhip_kinds)	{ [band_battle_party_relationship_kind, dating_partners_party_relationship_kind] }

end

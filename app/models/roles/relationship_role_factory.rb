module Roles
	class RelationshipRoleFactory

		attr_accessor :party_role, :related_party_role, :party_relationship


    def self.call(party, party_role_kind_key, party_relationship_kind_key, related_party)
      build(party, args).party_role
    end

  	# look up party_role_kind
  	# look up party_relationship kind
  	# verify the party_relationship includes the passed party_role_kind in the relationship pair
  	# build party_roles for both the source party and related party
  	# instantiate a new party_relationship instance populated with the party_role instances
  	# validate the relationship isn't already present for these parties

    def initialize(party, party_role_kind_key, party_relationship_kind_key, related_party)
    	@party 												= party
    	@party_role_kind_key 					= party_role_kind_key
    	@party_relationship_kind_key 	= party_relationship_kind_key
    	@related_party 								= related_party

			@party_relationship_kind = nil
			@party_relationship = nil

			@party_role_kind = nil
    	@party_role = nil

			@related_party_role_kind = nil
			@related_party_role = nil

    	find_party_role_kind
    	find_party_relationship_kind
    	verify_party_role_pair

    	build_party_role
    	build_related_party_role

    	initilize_party_relationship
    	validate_unique_relationship
    end

    def find_party_role_kind
    	@party_role_kind = Parties::PartyRoleKind.find_by(key: @party_role_kind_key)
    end

    def find_party_relationship_kind
    	@party_relationship_kind = Parties::PartyRelationshipKind.find_by(key: @party_relationship_kind_key)
    end

    def verify_party_role_pair
    	if @party_relationship_kind.party_role_kinds.include?(@party_role_kind)
    		@related_party_role_kind = (@party_relationship_kind.party_role_kinds - @party_role_kind).first
    	else
    		# Error condition, the passed party_role_kind isn't in the relationshiop definition
    	end
    end

    def initilize_party_relationship
    	@party_relationship = Parties::PartyRelationship.new(party_relationship_kind: @party_relationship_kind, party_roles: [@party_role, @related_party_role])
    end

    def validate_unique_relationship
    	# Error condition, this relationship already exists

    	# compare active relationship with same relationship_kind and party pair 

			# if @party.active_party_roles.detect { |role| @party_relationship_kind.present && 
			# 																						(role.party_relationship_kind == @party_relationship_kind) &&
			# 																						(role.party_role_kind == party_role_kind)
			# 																					}
			# end
    end

    def build_party_role
    	@party_role = party.party_roles.build(party_role_kind: @party_role_kind)
    end

    def build_related_party_role
    	@related_party_role = related_party.party_roles.build(party_role_kind: @related_party_role_kind)
    end

    def party_role
      @party_role
    end

    def related_party_role
      @related_party_role
    end

    def party_relationship
      @party_relationship
    end

	end
end

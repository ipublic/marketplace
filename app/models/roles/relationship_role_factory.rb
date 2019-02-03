module Roles
	class RelationshipRoleFactory

		attr_accessor :party_role


    def self.call(party, args)
      build(party, args).party_role
    end

    def self.validate(party_role)
      # TODO: Add validations
      # Validate open enrollment period
      true
    end

  	# look up party_role_kind
  	# find party_relationship_kind(s) it belongs to
  	# verify presence of party_relationship_kind
  	# build party_role
  	# verify there isn't an existing active duplicate party_relationship_role for this party
  	# assign party_role kind to this party
  	# assign party_role to related_party
  	# add new party_role to party_roles

    def initialize(party, args)
    	@party = party
    	@party_role = nil
			@party_role_kind = nil
			@party_relationship_kind = nil

    	@party_role_kind_key 					= args[:party_role_kind_key]
    	@party_relationship_kind_key 	= args[:party_relationship_kind_key]
    	@related_party 								= args[:related_party]

    	find_party_role_kind
    	find_party_relationship_kind

    	build_party_role
    	create_party_relationship
    end

    def build_party_role
    	@party_role = party.party_roles.build(party_role_kind: @party_role_kind, party_relationship: @party_relationship_kind = nil)
    end

    def find_party_role_kind
    	@party_role_kind = Parties::PartyRoleKind.find_by(key: @party_role_kind_key)
    end

    def find_party_relationship_kind
    	@party_relationship_kind = Parties::PartyRelationshipKind.find_by(key: @party_relationship_kind_key)
    end

    def create_party_relationship
    	@party_role.build_party_relationship(party_relationship_kind: @party_relationship_kind)
    end

    def is_duplicate_party_role?
    end

    def active_party_roles
    end

    def party_role
      @party_role
    end

    protected

    def assign_application_attributes(args)
      return nil if args.blank?
      args.each_pair do |k, v|
        @benefit_application.send("#{k}=".to_sym, v)
      end
    end

	end
end

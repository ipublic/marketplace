module Roles
	class RoleFactory

		attr_accessor :party_role


    def self.call(party, party_role_kind_key)
      build(party, args).party_role
    end

  	# look up party_role_kind
  	# validate role isn't already active for this party

    def initialize(party, party_role_kind_key)
    	@party 												= party
    	@party_role_kind_key 					= party_role_kind_key

			@party_role_kind = nil
    	@party_role = nil

    	find_party_role_kind
    	build_party_role
    	validate_unique_role
    end

    def find_party_role_kind
    	@party_role_kind = Parties::PartyRoleKind.find_by(key: @party_role_kind_key)
    end

    def build_party_role
    	unless @party.active_party_roles.detect { |role| role.key == party_role_kind_key }
	    	@party_role = party.party_roles.build(party_role_kind: @party_role_kind)
    	else
    		# Error condintion, party already has this active role
    	end
    end

    def party_role
      @party_role
    end

  end
end

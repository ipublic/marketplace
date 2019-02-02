module EligibilityPolicies
	class EligibilityPolicy
	  include Mongoid::Document
    include Mongoid::Timestamps

	  belongs_to	:party_relationship_kinds,
	  						class_name: 'Parties::PartyRelationshipKind'

	end
end

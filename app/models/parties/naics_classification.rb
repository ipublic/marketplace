module Parties
	class NaicsClassification
	  include Mongoid::Document

	  embedded_in :organization_party,
	  						class_name: 'Parties::OrganizationParty'

		field :code, 				type: String
		field :title, 			type: String
		field :year,				type: Integer, default: 2017
		field :description, type: String
	end
end

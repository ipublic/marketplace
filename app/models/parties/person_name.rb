module Parties
	class PersonName
	  include Mongoid::Document

	  embedded_in :person_party,
	  						class_name: "Parties::PersonParty"

	  field :first_name, 	type: String
	  field :middle_name,	type: String
	  field :last_name, 	type: String
	  field :name_pfx, 		type: String
	  field :name_sfx, 		type: String

	  field :start_date,	type: Date
	  field :end_date,	  type: Date
	end
end

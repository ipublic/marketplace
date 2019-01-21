class Parties::IndividualParty < Party


  field :current_first_name, 	type: String
  field :current_last_name, 	type: String


  embeds_many :determinations,
  						class_name: "Determinations::Determination"

	def all_party_roles
		super + [
				:individual_unemployment_insurance_sponsor,
				:unemployment_insurance_claiment,
				:paid_family_leave_claiment,
				:employee,
  			:patient_practitioner,
			]
	end

end

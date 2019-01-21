class Parties::IndividualParty < Party


  field :current_first_name, 	type: String
  field :current_last_name, 	type: String


  embeds_many :determinations,
  						class_name: "Determinations::Determination"


  scope :employed_by, 	-> (party){} # party_relationship of employment, with 
  scope :contacts_for, 	-> (party){}


	def all_party_roles
		super + [
				:unemployment_insurance_individual_sponsor,
				:unemployment_insurance_claiment,
				:paid_family_leave_claiment,
				:employee,
				:health_insurance_contract_holder,
  			:patient_practitioner,
			]
	end

end

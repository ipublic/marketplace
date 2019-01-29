module Parties
	class PersonParty < Party

	  GENDER_KINDS = %W(male female)

	  field :business_title,			type: String

	  field :current_first_name, 	type: String
	  field :current_middle_name,	type: String
	  field :current_last_name, 	type: String
	  field :current_name_pfx, 		type: String
	  field :current_name_sfx, 		type: String

	  field :ssn, 								type: String
	  field :gender, 							type: String
  	field :dob, 								type: Date

  	embeds_many	:person_names,
  							class_name: "Parties::PersonName"

  	embeds_many	:party_roles,
  							class_name: "Parties::PersonName"

    has_one			:party_ledger,
    						class_name: 'Parties::PartyLedger'

		has_one			:party_ledger_account_balance,
								class_name: 'Parties::PartyLedgerAccountBalance'


	  # embeds_many :addresses
	  # embeds_many :phones
	  # embeds_many :emails

	  validates_presence_of	:current_first_name, :current_last_name

	  validates :ssn, uniqueness: true, allow_blank: true

	  validates :gender,
	    allow_blank: true,
	    inclusion: { in: GENDER_KINDS, message: "%{value} is not a valid gender" }

	  index({current_last_name: 1, current_first_name: 1})
	  index({current_first_name: 1, current_last_name: 1})
	  index({dob: 1}, {sparse: true})

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


		def individual_roles
			[
				:customer,
				:supplier,
			]
		end


		def seed_party_role_kinds
			# Parties::PartyRoleKind.create(key: :employee, has_related_party: true, related_party_roles: [], 

			Parties::PartyRoleKind.create({key: :unemployment_insurance_agency_administrator, title: "", description: "", is_published: true})

			Parties::PartyRoleKind.create({key: :unemployment_insurance_group_sponsor, title: "", description: "An employer who manages unemployment insurance tax for its employees", is_published: true})
			Parties::PartyRoleKind.create({key: :unemployment_insurance_individual_sponsor, title: "", description: "", is_published: true})
			Parties::PartyRoleKind.create({key: :unemployment_insurance_tpa, title: "", description: "", is_published: true})
			Parties::PartyRoleKind.create({key: :unemployment_insurance_tpa_agent, title: "", description: "", is_published: true})
			Parties::PartyRoleKind.create({key: :unemployment_insurance_claiment, title: "", description: "", is_published: true})

			Parties::PartyRoleKind.create({key: :paid_family_leave_group_sponsor, title: "", description: "", is_published: true})
			Parties::PartyRoleKind.create({key: :paid_family_leave_tpa, title: "", description: "", is_published: true})
			Parties::PartyRoleKind.create({key: :paid_family_leave_tpa_agent, title: "", description: "", is_published: true})
			Parties::PartyRoleKind.create({key: :paid_family_leave_claiment, title: "", description: "", is_published: true})

			Parties::PartyRoleKind.create({key: :employee, title: "", description: "", is_published: true})

			Parties::PartyRoleKind.create({key: :health_insurance_group_sponsor, title: "", description: "An employer or organization who sponsors health insurance benefits for its members", is_published: true})
			Parties::PartyRoleKind.create({key: :health_insurance_contract_holder, title: "", description: "", is_published: true})
		end

	end
end

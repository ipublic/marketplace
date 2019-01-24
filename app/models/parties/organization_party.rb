class Parties::OrganizationParty < Party

  field :uits_account_id,		type: Integer
  field :pflts_account_id,	type: Integer
	field :fein, 							type: String
	field :legal_name, 				type: String

  field :entity_kind, type: String
  field :sic_code, type: String

  embeds_many :naics_classifications,
  						class_name: 'Parties::NaicsClassifications'

  validates_presence_of	:fein, :legal_name

	index({ fein: 1 })
	index({ legal_name: 1 })


	def all_party_roles
		super + [
				:health_insurance_group_sponsor,
				:unemployment_insurance_group_sponsor,
				:paid_family_leave_group_sponsor
			]
	end

end

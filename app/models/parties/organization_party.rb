class Parties::OrganizationParty < Party

	field :fein, type: String

	def all_party_roles
		super + [
				:health_insurance_group_sponsor,
				:unemployment_insurance_group_sponsor,
				:paid_family_leave_group_sponsor
			]
	end

end

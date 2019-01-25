module Parties
	class OrganizationParty < Party

	  ENTITY_KINDS = [
	    :tax_exempt_organization,
	    :c_corporation,
	    :s_corporation,
	    :partnership,
	    :limited_liability_corporation,
	    :limited_liability_partnership,
	    :household_employer,
	    :governmental_employer,
	    :foreign_embassy_or_consulate,
	  ]

	  # Shared Unemployment Insurance and PFL ID
	  field :entity_id,		type: Integer

	  # Federal Employer ID Number
		field :fein, 							type: String

	  # Registered legal name
		field :legal_name, 				type: String

	  # Doing Business As (alternate name)
	  field :dba, type: String

	  field :entity_kind, 			type: Symbol
	  field :is_foreign_entity,	type: Boolean # DC Corporation?

	  has_many		:financial_accounts,
	  						class_name: 'FinancialAccounts::FinancialAccount'

    has_many 		:wage_reports, 
    						class_name: "Wages::WageReport"

    embeds_many :determinations, 
    						class_name: "Determinations::Determination"

	  embeds_many :naics_classifications,
	  						class_name: 'Parties::NaicsClassifications'

	  embeds_many :documents, as: :documentable

	  validates_presence_of	:uits_account_id, :pflts_account_id, :fein, :legal_name, :entity_kind, :is_foreign_entity

		index({ uits_account_id: 1 })
		index({ pflts_account_id: 1 })
		index({ fein: 1 })
		index({ legal_name: 1 })

		alias_method :is_foreign_entity?, :is_foreign_entity

		def all_party_roles
			super + [
					:health_insurance_group_sponsor,
					:unemployment_insurance_group_sponsor,
					:paid_family_leave_group_sponsor
				]
		end
	end
end

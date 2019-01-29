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
	  field :entity_id,					type: Integer

	  # Federal Employer ID Number
		field :fein,							type: String

	  # Registered legal name
		field :legal_name,				type: String

	  # Doing Business As (alternate name)
	  field :dba, 							type: String

	  field :entity_kind, 			type: Symbol
	  field :is_foreign_entity,	type: Boolean # DC Corporation?

    has_many 		:wage_reports, 
    						class_name: "Wages::WageReport"

    has_one			:party_ledger,
    						class_name: 'Parties::PartyLedger',
	  						autobuild: true

		has_one			:party_ledger_account_balance,
								class_name: 'Parties::PartyLedgerAccountBalance',
	  						autobuild: true

	  embeds_many :naics_classifications,
	  						class_name: 'Parties::NaicsClassification'

    validates :entity_kind,
      inclusion: { in: ENTITY_KINDS, message: "%{value} is not a valid business entity kind" },
      allow_blank: false

    validates :fein,
      presence: true,
      length: { is: 9, message: "%{value} is not a valid FEIN" },
      numericality: true,
      uniqueness: true

    validates :entity_id,
      presence: true,
      numericality: true,
      uniqueness: true

	  validates_presence_of	:legal_name, :is_foreign_entity

		index({ entity_id: 1 },		{ unique: true})
    index({ legal_name: 1 })
    index({ dba: 1 },   			{ sparse: true })
    index({ fein: 1 },  			{ unique: true, sparse: true })

		alias_method :is_foreign_entity?, :is_foreign_entity

    # Strip non-numeric characters
    def fein=(new_fein)
      numeric_fein = new_fein.to_s.gsub(/\D/, '')
      write_attribute(:fein, numeric_fein)
      @fein = numeric_fein
    end

    def entity_kinds
      ENTITY_KINDS
    end

		def all_party_roles
			super + [
					:health_insurance_group_sponsor,
					:unemployment_insurance_group_sponsor,
					:paid_family_leave_group_sponsor
				]
		end

    class << self

      def search_hash(s_rex)
        search_rex = ::Regexp.compile(::Regexp.escape(s_rex), true)
        {
          "$or" => ([
            {"legal_name" => search_rex},
            {"fein" => search_rex},
          ])
        }
      end
    end
	end
end

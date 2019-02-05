module Parties
	class OrganizationParty < Party

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

	  embeds_many :naics_classifications,
	  						class_name: 'Parties::NaicsClassification'

    validates :fein,
      presence: true,
      length: { is: 9, message: "%{value} is not a valid FEIN" },
      numericality: true
      #uniqueness: true

	  # embeds_many :documents, as: :documentable

	  validates_presence_of :fein, :legal_name, :is_foreign_entity

		# index({ entity_id: 1 },		{ unique: true})
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

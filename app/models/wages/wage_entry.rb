module Wages
	class WageEntry
	  include Mongoid::Document
	  include Mongoid::Timestamps

	  SUBMISSION_KINDS = [:original, :ammended]

		# attr_readonly :submission_kind, :submitted_at

	  embedded_in	:wage_report,
	  						class_name: 'Wages::WageReport'

	  field :submission_kind,	type: Symbol, default: :original
	  field :submitted_at, 		type: Time, 	default: ->{ Time.now }

	  embeds_one	:wage,
	  						class_name: 'Wages::Wage'

		validates_presence_of :wage, :submitted_at

    validates :submission_kind,
      inclusion: { in: SUBMISSION_KINDS, message: "%{value} is not a valid submission kind" },
      allow_blank: false

    # after_initialize :build_wage

    delegate :timespan, 								to: :wage_report
    delegate :person_party, 						to: :wage
	  delegate :state_total_gross_wages,	to: :wage
	  delegate :state_total_wages,				to: :wage
	  delegate :state_excess_wages,				to: :wage
	  delegate :state_taxable_wages,			to: :wage

	  private

	  def build_wage_instance
	  	wage.build(timespan: timespan)
	  end

	end
end

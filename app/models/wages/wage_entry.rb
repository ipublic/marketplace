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

		validates_presence_of :wage, :submission_kind, :submitted_at

	end
end

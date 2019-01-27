module Wages
	class WageEntry
	  include Mongoid::Document

	  KIND = [:original, :ammended]

	  embedded_in	:wage_report,
	  						class_name: 'Wages::WageReport'

	  field :kind, type: Symbol, default: :original
	  field :submitted_at, type: Time

	  embeds_one	:wage,
	  						class_name: 'Wages::Wage'

	end
end

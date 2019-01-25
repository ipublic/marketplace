module FinancialAccounts
	class ContributionRate
  include Mongoid::Document

	  embedded_in	:financial_account,
	  						class_name: 'FinancialAccounts::FinancialAccount'

		embeds_one	:timespan,
								class_name: 'Timespans::Timespan'

	  field :efffective_on,				type: Date
	  field :determined_at,				type: Time

	end
end

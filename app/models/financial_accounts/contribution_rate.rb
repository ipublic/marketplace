module FinancialAccounts
	class ContributionRate
  include Mongoid::Document

	  field :effective_on,				type: Date
	  field :determined_at,				type: Time, default: TimeKeeper.date_of_record

	  embedded_in	:financial_account,
	  						class_name: 'FinancialAccounts::FinancialAccount'

	  belongs_to 	:timespan, 
								class_name: 'TimeSpans::Timespan'



	end
end

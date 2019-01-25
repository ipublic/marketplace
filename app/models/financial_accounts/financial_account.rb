module FinancialAccounts
	class FinancialAccount
	  include Mongoid::Document
	  include Mongoid::Timestamps

	  field :title, 			type: String
	  field :opened_on, 	type: String

	  embeds_many		:contribution_rates,
	  							class_name: 'FinancialAccounts::ContributionRate'

	  belongs_to		:party,
	  							class_name: 'Parties::Party'

	  has_many 			:financial_transactions,
	  							class_name: 'FinancialAccounts::FinancialTransactions'

	  belongs_to 		:timespan, 
	  							class_name: 'TimeSpans:Timespan'

	end
end

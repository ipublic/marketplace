module FinancialAccounts
	class FinancialAccount
	  include Mongoid::Document
	  include Mongoid::Timestamps

	  belongs_to		:party,
	  							class_name: 'Parties::Party'

	  field :title, 			type: String
	  field :opened_on, 	type: String

	  embeds_many		:contribution_rates,
	  							class_name: 'FinancialAccounts::ContributionRate'

	  has_many 			:financial_transactions,
	  							class_name: 'FinancialAccounts::FinancialTransactions'

	end
end

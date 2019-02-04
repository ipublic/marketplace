module FinancialAccounts
	class FinancialAccount
	  include Mongoid::Document
	  include Mongoid::Timestamps

	  field :title, 						type: String
	  field :opened_on, 				type: Date, default: ->{ TimeKeeper.date_of_record }

	  belongs_to		:party_ledger,
	  							class_name: 'FinancialAccounts::PartyLedger'

	  has_many 			:financial_transactions,
	  							class_name: 'FinancialAccounts::FinancialTransactions'

	  validates_presence_of :title, :opened_on

	end
end

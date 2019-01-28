module FinancialAccounts
	class PartyLedger
  include Mongoid::Document


	  belongs_to	:party,
	  						class_name: 'Parties::Party'

	  has_many	:fianancial_accounts,
	  					class_name: 'FinancialAccounts::FinancialAccount'

	end
end

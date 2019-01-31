module FinancialAccounts
	class PartyLedger
  include Mongoid::Document

  	field :total_due, type: BigDecimal


	  belongs_to	:party,
	  						class_name: 'Parties::Party'

	  has_many		:fianancial_accounts,
	  						class_name: 'FinancialAccounts::FinancialAccount'

		has_many		:party_ledger_account_balances,
								class_name: 'Parties::PartyLedgerAccountBalance'

		has_many		:timespans,
								class_name: 'Timespans:Timespan'

	end
end

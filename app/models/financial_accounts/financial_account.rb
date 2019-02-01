module FinancialAccounts
	class FinancialAccount
	  include Mongoid::Document
	  include Mongoid::Timestamps

	  field :title, 						type: String
	  field :opened_on, 				type: Date, default: ->{ TimeKeeper.date_of_record }
	  field :current_balance, 	type: BigDecimal, default: 0.0

	  # embeds_many		:contribution_rates,
	  # 							class_name: 'FinancialAccounts::ContributionRate'

	  belongs_to		:party_ledger,
	  							class_name: 'FinancialAccounts::PartyLedger'

	  # has_many 			:financial_transactions,
	  # 							class_name: 'FinancialAccounts::FinancialTransactions'

	  validates_presence_of :title, :opened_on

    def contribution_rates
      contribution_rates.order(effective_on: :desc).order(determined_at: :desc)
    end

    def latest_contribution_rate
      contribution_rates.first
    end


	end
end

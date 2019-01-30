module FinancialAccounts
	class FinancialAccount
	  include Mongoid::Document
	  include Mongoid::Timestamps

	  field :title, 			type: String
	  field :opened_on, 	type: Date, default: ->{ Date.today }

	  # embeds_many		:contribution_rates,
	  # 							class_name: 'FinancialAccounts::ContributionRate'

	  belongs_to		:party,
	  							class_name: 'Parties::Party'

	  # has_many 			:financial_transactions,
	  # 							class_name: 'FinancialAccounts::FinancialTransactions'

	  belongs_to 		:timespan, 
	  							class_name: 'TimeSpans:Timespan', optional:true

		# validates_presence_of :opened_on, :party


    def contribution_rates
      contribution_rates.order(effective_on: :desc).order(determined_at: :desc)
    end

    def latest_contribution_rate
      contribution_rates.first
    end


	end
end

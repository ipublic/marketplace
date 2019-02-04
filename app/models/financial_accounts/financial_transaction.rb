module FinancialAccounts
	class FinancialTransaction
	  include Mongoid::Document

	  # TODO Make transaction immutable

	  belongs_to :financial_account,
	  						class_name: 'FinancialAccounts.FinancialAccount'

    field :title, 				type: String
    field :memo, 					type: String
    field :kind, 					type: Symbol
    field :amount, 				type: BigDecimal, default: 0.0
    field :effective_on, 	type: Date, 			default: ->{ TimeKeeper.date_of_record }
    field :submitted_at, 	type: Time, 			default: ->{ TimeKeeper.date_time_of_record }

    # Reference the source transaction in Ledger system
    field :source_foreign_key, 		type: String

    validates_presence_of :title, :kind, :amount, :effective_on, :submitted_at

 	end
end

module FinancialAccounts
	class PflFinancialAccount
	  include Mongoid::Document

    field :pfl_tax_rate,              type: Float, default: 0.0
    field :pfl_wage_filing_schedule,  type: Symbol

  end
end

module FinancialAccounts
  class UiFinancialAccount < FinancialAccount

    # Account states:
    # Current
    # Overdue - oustanading balance last day of every month (reimburse, contribute)
    # Delinquent - 60 days after delinquency notice, system identifies employers with missing reports, calculates estimated report
    # Quarter Delinquent - (management designation) 60 days after end of quarter. Generate Deliquency Notice
    # Closed
    #   Reason: Written Off

    include Mongoid::Document

    # Initial date employer became liable for UI tax
    field :status,                        type: Symbol, default: :active

    field :ledger_system_account_id,      type: BSON::ObjectId

    field :initial_liability_date,        type: Date,   default: ->{ TimeKeeper.date_of_record }
    field :current_payment_kind,          type: Symbol, default: :uits_contributing
    field :current_wage_filing_schedule,  type: Symbol, default: :uits_qtr_filer
    field :current_administrative_rate,   type: Float,  default: 0.0
    field :current_contribution_rate,     type: Float,  default: 0.0

    #embeds_many :filing_statuses    # wage report filed for timespans
    #embeds_many :payment_status     # financial transactions for timespans

    validates_presence_of :initial_liability_date, :status, :current_payment_kind, :current_wage_filing_schedule

    def current_balance
      financial_transactions.reduce(0.0) { |totoal, transaction| total + transaction.amount }
    end

  end
end

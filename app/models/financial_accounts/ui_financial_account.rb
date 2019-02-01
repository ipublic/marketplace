module FinancialAccounts
  class UiFinancialAccount < FinancialAccount
    include Mongoid::Document

    # Initial date employer became liable for UI tax
    field :initial_liability_date,        type: Date 
    field :status,                        type: Symbol, default: :active

    field :ledger_system_account_id,      type: BSON::ObjectId

    field :current_payment_type,          type: Symbol
    field :current_wage_filing_schedule,  type: Symbol

    embeds_many :filing_statuses    # wage report filed for timespans
    embeds_many :payment_status     # financial transactions for timespans


    validates_presence_of :initial_liability_date, :status, :current_payment_type, :current_wage_filing_schedule

    # Account states:
    # Current
    # Overdue - oustanading balance last day of every month (reimburse, contribute)
    # Delinquent - 60 days after delinquency notice, system identifies employers with missing reports, calculates estimated report
    # Quarter Delinquent - (management designation) 60 days after end of quarter. Generate Deliquency Notice
    # Closed
    #   Reason: Written Off

    def assign_schedule_and_payment

      
    end

  end
end

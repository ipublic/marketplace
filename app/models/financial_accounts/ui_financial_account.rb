module FinancialAccounts
  class UiFinancialAccount < FinancialAccount
    include Mongoid::Document

    PAYMENT_TYPES 				= [:contribute, :reimburse, ]
    WAGE_FILING_SCHEDULES = [:quarter, :annual]

    field :payment_type, 					type: Symbol
    field :wage_filing_schedule, 	type: Symbol

    embeds_many :filing_statuses 	# wage report filed for timespans
    embeds_many :payment_status		# financial transactions for timespans

    # Initial date employer became liable for UI tax
    field :liability_date,        type: Date 

    field :status,                type: Symbol, default: :active

    # Account states:
    # Current
    # Overdue - oustanading balance last day of every month (reimburse, contribute)
    # Delinquent - 60 days after delinquency notice, system identifies employers with missing reports, calculates estimated report
    # Quarter Delinquent - (management designation) 60 days after end of quarter. Generate Deliquency Notice
    # Closed
    #   Reason: Written Off

    before_save :set_title

    private

    def set_title
      write_attribute(:title, "Unemployment Insurance Account") if title.blank?
    end

  end
end

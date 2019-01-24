class FinancialAccounts::UiFinancialAccount
  include Mongoid::Document

  PAYMENT_TYPES 				= [:contributory]
  WAGE_FILING_SCHEDULES = [:quarterly, :annually]

  field :payment_type, 					type: Symbol
  field :wage_filing_schedule, 	type: Symbol

  embeds_many :filing_statuses 	# wage report filed for timespans
  embeds_many :payment_status		# financial transactions for timespans

  # Initial date employer became liable for UI tax
  field :liability_date, type: Date 

  field :status, type: Symbol, default: :active


end

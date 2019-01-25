module Wages
	class WageReport
	  include Mongoid::Document

	  REPORT_TYPES 				= [:original, :ammended]
	  STATUS_KINDS 				= [:processed]
	  FILING_METHOD_KINDS = [:upload, :manual_entry, :no_wages]

	  SUBMISSION_TYPES 		= [:original, :ammended]

	  belongs_to	:organization_party,
	  						class_name: 'Parties::OrganizationParty'

	  belongs_to 	:ui_tax_timespan, 
	  						class_name: 'TimeSpans:UiTaxTimespan'

		field :timespan_id,								type: BSON::ObjectId

	  field :submitted_at, 							type: Time
	  field :submitted_by_id, 					type: BSON::ObjectId
	  field :user_account_id, 					type: BSON::ObjectId
	  field :status,										type: Symbol
	  field :submission_type,						type: Symbol

	  field :filing_method,							type: Symbol

	  field :ui_tax_rate,								type: Float, default: 0.0
	  field :ui_wage_filing_schedule,		type: Symbol

	  field :pfl_tax_rate,							type: Float, default: 0.0
	  field :ui_wage_filing_schedule,		type: Symbol

	  field :total_wages, 							type: BigDecimal
	  field :taxable_wages, 						type: BigDecimal
	  field :excess_wages, 							type: BigDecimal

	  field :ui_tax_contribution, 			type: BigDecimal
	  field :ui_admin_fee_contribution,	type: BigDecimal
	  field :ui_interest_charges_paid, 	type: BigDecimal
	  field :ui_penalty_charges_paid, 	type: BigDecimal

	  field :ui_total_due, 							type: BigDecimal
	  field :ui_paid_amount, 						type: BigDecimal
	  field :ui_amount_due, 						type: BigDecimal
	end
end

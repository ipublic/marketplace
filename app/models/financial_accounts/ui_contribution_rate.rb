module FinancialAccounts
	class UiContributionRate < ContributionRate
	  include Mongoid::Document

    EMPLOYER_TAXABLE_WAGE_MAX = 2_000_000
    EMPLOYEE_TAXABLE_WAGE_MAX = 9_000

	  # RATE_KINDS = [:unempmloyment_insurance, :administrative_fee]
	  # field :rate_kind, type: Symbol

    field :ui_wage_filing_schedule,	type: Symbol
	  field :ui_tax_rate,							type: Float, default: 0.0
	  field :ui_administrative_rate,	type: Float, default: 0.0
	  field :ui_combined_rate, 				type: Float

	  before_save :set_ui_combined_rate

	  def calculate_ui_combined_rate
	  	ui_tax_rate -	ui_administrative_rate
	  end

	  private

	  def set_ui_combined_rate
	  	write_attribute(:ui_combined_rate, calculate_ui_combined_rate) if ui_combined_rate.blank?
	  end

	end
end

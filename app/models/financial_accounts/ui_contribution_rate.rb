module FinancialAccounts
	class UiContributionRate < ContributionRate
	  include Mongoid::Document

	  # RATE_KINDS = [:unempmloyment_insurance, :administrative_fee]
	  # field :rate_kind, type: Symbol

	  field :ui_rate, 						type: Float, default: 0.0
	  field :administrative_rate,	type: Float, default: 0.0
	  field :combined_rate, 			type: Float

	  before_save :set_combined_rate

	  def calculate_combined_rate
	  	ui_rate + administrative_fee
	  end

	  private

	  def set_combined_rate
	  	write_attribute(:combined_rate, calculate_combined_rate) if combined_rate.blank?
	  end

	end
end

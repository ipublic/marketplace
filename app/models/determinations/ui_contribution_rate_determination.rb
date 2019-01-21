class Determinations::UiContributionRateDetermination
  include Mongoid::Document

  embedded_in :party, 
  						class_name: "Parties::Party"


  field :calendar_year_period_id, 					type: BSON::ObjectId
  field :predecessor_id, 										type: BSON::ObjectId
  field :tax_rate, 													type: Float, default: 0.0
  field :administration_fee, 								type: Float, default: 0.0
  field :initial_tax_rate, 									type: Float, default: 0.0
  field :variable_adjustment_factor,				type: Float, default: 0.0

  field :reserve_account_starting_balance, 	type: BigDecimal, default: 0.0
  field :contribution_amount, 							type: BigDecimal, default: 0.0
  field :interest_earned_amount, 						type: BigDecimal, default: 0.0
  field :reserve_account_ending_balance, 		type: BigDecimal, default: 0.0

  # Algorithm based on FL formula
	def initialize(benefit_sponsor, next_calendar_year_period, determination_timespan = 3.years)
		final_adjustment_factor 		= -0.0001

		variable_adjustment_factor  = next_calendar_year_period.adjustment_factor

		calendar_year_period_id 		= next_calendar_year_period._id
		administration_fee 					= next_calendar_year_period.administration_fee
		initial_tax_rate 						= next_calendar_year_period.initial_tax_rate
		maximum_tax_rate 						= next_calendar_year_period.maximum_tax_rate
		tax_rate 										= [raw_tax_rate, maximum_tax_rate].min


		reserve_account_starting_balance	= benefit_sponsor.reserve_balance_on(prior_year_period.start_on - 1.day)
		contribution_amount 							= benefit_sponsor.net_contribution_amount_for(prior_year_period)
		interest_earned_amount						= benefit_sponsor.interest_income_for(prior_year_period)
		reserve_account_ending_balance 		= previous_reserve + interest_earned + benefit_contributions - benefits_charged
	end

	def raw_tax_rate
		[benefit_ratio + variable_adjustment_factor + final_adjustment_factor, initial_tax_rate].max
	end

	def determination_period
		(next_calendar_year_period.start_on - determination_timespan)..(next_calendar_year_period.start_on - 1.day)
	end

	def prior_year_period
		(next_calendar_year_period.start_on - 1.year)..(next_calendar_year_period.start_on - 1.day)
	end

	def taxable_wages
		benefit_sponsor.sum_taxable_wages_for(determination_period)
	end

	def benefit_charges
		benefit_sponsor.sum_benefit_charges_for(determination_period)
	end

  def benefit_ratio
  	taxable_wages > 0 ? (benefit_charges / taxable_wages) : 0.0
	end

end

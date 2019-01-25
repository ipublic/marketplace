module Wages
	class Wage
	  include Mongoid::Document
	  include Mongoid::Timestamps

	  WAGE_TYPES = [:exempt, :nonexempt, :tip]

	  embedded_in	:wage_report,
	  						class_name: 'Wages::WageReport'

	  field :person_party_id,							type: BSON::ObjectId

	  field :state_qtr_total_gross_wages,	type: BigDecimal

	  # Business Domain Logic calculates these values
	  field :state_qtr_ui_total_wages,		type: BigDecimal
	  field :state_qtr_ui_excess_wages,		type: BigDecimal
	  field :state_qtr_ui_taxable_wages,	type: BigDecimal


	  validates_presence_of :state_qtr_ui_total_wages, :state_qtr_ui_excess_wages, :state_qtr_ui_taxable_wages


	  def person_party=(new_person_party)
	  end
	  
	  def person_party
	  end
	  
	end
end

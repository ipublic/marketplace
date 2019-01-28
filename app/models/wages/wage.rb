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


	  validates_presence_of :person_party_id, :state_qtr_ui_total_wages, :state_qtr_ui_excess_wages, :state_qtr_ui_taxable_wages

    index({ person_party_id: 1})

	  def person_party=(new_person_party)
      if new_person_party.nil?
        write_attribute(:new_person_party, nil)
      else
        raise ArgumentError.new("expected Parties::PersonParty") unless new_person_party.is_a? Parties::PersonParty
        write_attribute(:person_party_id, new_person_party._id)
      end
      @person_party = new_person_party
	  end
	  
	  def person_party
	    return nil if person_party_id.blank?
	    return @person_party if defined? @person_party
	    @person_party = Parties::PersonParty.find(person_party_id)
	  end

	end
end

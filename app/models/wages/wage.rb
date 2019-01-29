module Wages
	class Wage
	  include Mongoid::Document
	  include Mongoid::Timestamps

	  WAGE_KINDS = [:exempt, :nonexempt, :tip]

	  embedded_in	:wage_entry,
	  						class_name: 'Wages::WageEntry'

	  field :person_party_id,					type: BSON::ObjectId
	  field :timespan_id,							type: BSON::ObjectId

	  field :state_total_gross_wages,	type: BigDecimal
	  field :state_total_wages,				type: BigDecimal
	  field :state_excess_wages,			type: BigDecimal
	  field :state_taxable_wages,			type: BigDecimal

	  validates_presence_of :person_party_id, :timespan_id, :state_total_wages, :state_excess_wages, :state_taxable_wages

    index({ person_party_id: 1})
    index({ timespan_id: 1})

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

	  def timespan=(new_timespan)
      if new_timespan.nil?
        write_attribute(:new_timespan, nil)
      else
        raise ArgumentError.new("expected Timespans::Timespan") unless new_timespan.is_a? Timespans::Timespan
        write_attribute(:timespan_id, new_timespan._id)
      end
      @timespan = new_timespan
	  end
	  
	  def timespan
	    return nil if timespan_id.blank?
	    return @timespan if defined? @timespan
	    @timespan = Timespans::Timespan.find(timespan_id)
	  end

	end
end

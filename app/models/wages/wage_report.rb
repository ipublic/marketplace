module Wages

	TAXABLE_WAGES_MAXIMUM = 9_000
	
	class WageReport
	  include Mongoid::Document
	  include Mongoid::Timestamps

	  SUBMISSION_KINDS 				= [:original, :amended, :estimated]
	  FILING_METHOD_KINDS 		= [:upload, :manual_entry, :no_wages]

	  STATUS_KINDS 				= [:processed, :submitted, :terminated]

		# attr_readonly :submission_kind, :submitted_at

	  field :submitted_at, 							type: Time
	  field :submitted_by_id, 					type: BSON::ObjectId
	  field :user_account_id, 					type: BSON::ObjectId

	  field :status,										type: Symbol
	  field :submission_kind,						type: Symbol
	  field :filing_method_kind,				type: Symbol

	  field :state_total_gross_wages, 	type: BigDecimal

	  field :state_ui_total_wages, 			type: BigDecimal
	  field :state_ui_taxable_wages, 		type: BigDecimal
	  field :state_ui_excess_wages, 		type: BigDecimal

	  field :ui_tax_amount, 			type: BigDecimal
	  field :ui_admin_fee_amount,	type: BigDecimal
	  field :ui_interest_amount, 	type: BigDecimal
	  field :ui_penalty_amount, 	type: BigDecimal

	  field :ui_total_due, 							type: BigDecimal
	  field :ui_paid_amount, 						type: BigDecimal
	  field :ui_amount_due, 						type: BigDecimal

	  field :total_employees,						type: Integer

	  embeds_many	:wage_entries,
                class_name: 'Wages::WageEntry'
    
    # embeds_many	:wages,
	  # 						class_name: 'Wages::Wage'

	  belongs_to	:organization_party,
	  						class_name: 'Parties::OrganizationParty'

	  has_many 		:timespans, 
	  						class_name: 'Timespans::Timespan'

	  validates_presence_of :organization_party, :filing_method_kind,
	  											:submission_kind #:total_wages, 
	  											# :excess_wages, :taxable_wages


	  belongs_to	:timespan, 
	  						class_name: 'Timespans::Timespan'

	  # validates_presence_of :organization_party, :timespan, :wage_entries, :filing_method_kind,
	  # 											:submission_kind, :total_wages, 
	  # 											:excess_wages, :taxable_wages

    index({ organization_party_id: 1, timespan_id: 1 })
    index({ timespan_id: 1 })


    def set_state_wages
    	write_attributes(sum_all_state_wages)
    end

    def sum_state_total_wages
      wage_entries.map(&:wage).compact.reduce(0.0) do |subtotal, wage|
         subtotal += wage.state_total_gross_wages if  wage.state_total_gross_wages
        end
	  end

    def sum_state_excess_wages
     if (sum_state_total_wages - 9000) < 0 
      0 
     else
      sum_state_total_wages - 9000 
     end
	  end

    def sum_state_taxable_wages
      total = wage_entries.map(&:wage).compact.reduce(0.0) do  |subtotal, wage| 
        subtotal += wage.state_taxable_wages || 0 
      end
      if total > 9000
        9000
      else  
        total
      end
    end
    
    def ui_total_due
        sum_state_total_wages - sum_state_excess_wages
    end

          
    def ui_paid_amount
      0
    end


      
    def sum_state_ui_total_wages
      sum_state_total_wages
    end

	  # Calculate all wage values in one pass -- higher performance on large wage reports
    def sum_all_state_wages
      wage_entries.map do | wage_entry |
        total_wages 	+= wage_entry.state_total_gross_wages 
        excess_wages 	+= wage_entry.state_qtr_total_gross_wages
        taxable_wages += wage_entry.state_qtr_total_gross_wages 
        { state_total_wages: total_wages, state_excess_wages: excess_wages, state_taxable_wages: taxable_wages }
      end
    end

	  def sum_employees
	  	wage_entries.compact.uniq.size
    end

    def self.find_and_filter_wage_reports(org)
      org.wage_reports.sort{|a,b|b.timespan.begin_on - a.timespan.begin_on}
    end

    def self.find_and_filter_wage_reports_by_quarter(org, quarter)
      org.wage_reports.select{|d|d.timespan.begin_on == quarter.begin_on} 
    end
    


	  private 

	  def set_total_employees
	  	write_attribute(:total_employees, sum_employees)
	  end

	end
end

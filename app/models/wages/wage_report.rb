module Wages

	TAXABLE_WAGES_MAXIMUM = 9_000
	
	class WageReport
	  include Mongoid::Document
	  include Mongoid::Timestamps

	  SUBMISSION_KINDS 				= [:original, :ammended, :estimated]
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

	  validates_presence_of :organization_party, :timespans, :wage_entries, :filing_method_kind,
	  											:submission_kind #:total_wages, 
	  											# :excess_wages, :taxable_wages

    def self.filter_by_date_and_status(quarter)
      # require 'pry';
      # binding.pry
      where('timespans.begin_on' => quarter.begin_on).sort_by{|report|report.status}
    end
	  belongs_to	:timespan, 
	  						class_name: 'Timespans::Timespan'

	  # validates_presence_of :organization_party, :timespan, :wage_entries, :filing_method_kind,
	  # 											:submission_kind, :total_wages, 
	  # 											:excess_wages, :taxable_wages

    index({ organization_party_id: 1, timespan_id: 1 })
    index({ timespan_id: 1 })

    before_save :sum_employees

    def set_state_wages
    	write_attributes(sum_all_state_wages)
    end

	  def sum_state_total_wages
	  	wage_entries.reduce(0.0) { |subtotal, wage_entry| subtotal += wage_entry.state_total_gross_wages  }
	  end

	  def sum_state_excess_wages
	  	wage_entries.reduce(0.0) { |subtotal, wage_entry| subtotal += wage_entry.state_excess_wages  }
	  end

	  def sum_state_taxable_wages
	  	wage_entries.reduce(0.0) { |subtotal, wage_entry| subtotal += wage_entry.state_taxable_wages  }
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

    def self.latest(org)
      org.wage_reports.sort{|a,b| b.timespan.begin_on - a.timespan.begin_on}.first
    end

	  def sum_employees
	  	wage_entries.size
    end
    
    def update_entries(params)
      wage_entry_ids =  self.wage_entries.map(&:_id)
      wage_entry_ids.each do |id|
        wage = self.wage_entries.find(id).wage
        wage_params =  params[:wages_wage_report][:wage_entries][id.to_s][:wage]
        wage.update_attributes!(
          state_total_gross_wages: wage_params[:state_total_gross_wages],
          state_total_wages:wage_params[:state_total_wages],
          state_excess_wages: wage_params[:state_excess_wages],
          state_taxable_wages:wage_params[:state_taxable_wages]
        )
        self.update_attributes(submission_kind: :ammended, submitted_at: Time.now.to_date)
        self.save!
      end
      require 'pry';
      binding.pry
    end

    def clone_report
      cloned_report = self.clone 
      self.wage_entries.each do |we|
        new_wage = we.wage.clone
        new_we = we.clone
        new_we.wage = new_wage
        cloned_report.wage_entries  << new_we
        cloned_report.save!
      end

    end

	  private 

	  def set_total_employees
	  	write_attribute(:total_employees, sum_employees)
	  end

	end
end

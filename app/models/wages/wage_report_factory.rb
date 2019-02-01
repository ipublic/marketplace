module Wages
  class WageReportFactory

    attr_accessor :wage_report, :current_report

    def self.call(organization_party, report_timespan, args)
      new(organization_party, args).wage_report
    end

    def initialize
      @current_report = []
      @organization_party = organization_party
      @wage_report = organization_party.wage_reports.new
      @wage_report_template = nil
      @ui_contribution_report_determination = @organization_party.ui_contribution_report_determination_for(report_timespan)

      # assign_wage_report_attributes(args)
    	find_wage_report_template
      populate_wage_entries
    end

    def self.set_current_report(report)
      @current_report = report
    end

    def self.get_current_report 
      @current_report
    end

    def self.amend(report, report_timespan, params)
      cloned_report = report.clone 
      if params[:wages_wage_report][:new_wage_entry][:person_first_name].present?
        add_entries(cloned_report, params[:wages_wage_report][:new_wage_entry])
      end
      wage_entry_ids = cloned_report.wage_entries.map(&:_id)
      wage_entry_ids.each do |id|
        if params[:wages_wage_report][:wage_entries][id.to_s]
          update_clone(id,cloned_report,  params[:wages_wage_report][:wage_entries][id.to_s][:wage])
        end
      end
    end

    def self.add_entries(report, wage_params)
      person =  Parties::PersonParty.create!(current_first_name: wage_params[:person_first_name],current_last_name: wage_params[:person_last_name] )
      entry =  report.wage_entries.new(submission_kind: :amended, submitted_at: Time.now)
      entry.wage = Wages::Wage.new(
          person_party_id: person.id,
          timespan_id: report.timespan.id,
          state_total_gross_wages: wage_params[:state_total_gross_wages],
          state_total_wages: wage_params[:state_total_wages],
          state_excess_wages: wage_params[:state_excess_wages],
          state_taxable_wages:wage_params[:state_taxable_wages]
      )
      entry.save
      report.save
      set_current_report(report)
    end

    def self.update_clone(id,cloned_report, wage_params)
      wage = cloned_report.wage_entries.find(id).wage
      wage.update_attributes!(
        state_total_gross_wages: wage_params[:state_total_gross_wages],
        state_total_wages:wage_params[:state_total_wages],
        state_excess_wages: wage_params[:state_excess_wages],
        state_taxable_wages:wage_params[:state_taxable_wages]
      )
      cloned_report.update_attributes(submission_kind: :amended, 
      submitted_at: Time.now.to_date,
      state_total_gross_wages: cloned_report.sum_state_total_wages,
      state_ui_excess_wages: cloned_report.sum_state_excess_wages,
      state_ui_taxable_wages: cloned_report.sum_state_taxable_wages,
      )
      cloned_report.save!
    end

    def self.create_report(params)
      party = Parties::OrganizationParty.find(params[:employer_id])
      span = Timespans::Timespan.find(params[:quarter])
      report =  Wages::WageReport.create!(
        organization_party: party,
        timespan: span,
        submission_kind: :original,
        filing_method_kind: :manual_entry,
        status: :submitted,
        state_total_gross_wages: params[:wages_wage_report][:state_total_gross_wages],
        state_ui_taxable_wages: params[:wages_wage_report][:state_ui_taxable_wages],
        ui_total_due: params[:wages_wage_report][:ui_total_due],
        submitted_at: Time.now,
        state_ui_total_wages:params[:wages_wage_report][:state_ui_total_wages],
        state_ui_excess_wages: params[:wages_wage_report][:state_ui_excess_wages],
        ui_paid_amount:  params[:wages_wage_report][:ui_paid_amount],
        ui_tax_amount: params[:wages_wage_report][:ui_tax_amount],
        ui_amount_due:  params[:wages_wage_report][:ui_tax_amount],
        total_employees: params[:wages_wage_report][:total_employees])
      set_current_report(report)
    end


    def assign_wage_report_attributes(args)
      args.each_pair do |k, v|
        @wage_report.send("#{k}=".to_sym, v)
      end
    end

    # Any factors necessary here?
    def assign_wage_report_ui_contribution_factors
    end

    def populate_wage_entries
    	# Build subclasses
    	clone_from_wage_report_template
    end

    def build_original_report_wage_entries
    	# Build from prior time period template or from scratch (empty)
    end

    def build_ammended_report_submission_kind
    	# Build from same time period template
    end

    def find_wage_report_template
    	same_timespan_wage_report || preceding_timespan_wage_report
    end

    def same_timespan_wage_report
    	wage_report_list = Wages::WageReports.where(organization_party: organization_party, timespan: report_timespan).order(submitted_at: desc).entries

    	if wage_report_list.size > 0
    		@wage_report.submission_kind = :ammended
	    	@wage_report_template = wage_report_list.first
    	else
    		nil
	    end
    end

    def preceding_timespan_wage_report
    	wage_report_list = Wages::WageReports.where(organization_party: organization_party, timespan: report_timespan.predecessor).order(submitted_at: desc).entries

    	if wage_report_list.size > 0
    		@wage_report.submission_kind = :original
	    	@wage_report_template = wage_report_list.first
    	else
    		nil
	    end
    end

    def clone_from_wage_report_template
    end


    def self.validate(wage_report)
      # TODO: Add validations
      true
    end

  end
end

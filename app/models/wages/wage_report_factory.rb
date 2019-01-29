module Wages
  class WageReportFactory

    attr_accessor :wage_report

    def self.call(organization_party, report_timespan, args)
      new(organization_party, args).wage_report
    end

    def initialize(organization_party, report_timespan, args)
      @organization_party = organization_party
      @wage_report = organization_party.wage_reports.new
      @wage_report_template = nil
      @ui_contribution_report_determination = @organization_party.ui_contribution_report_determination_for(report_timespan)

      assign_wage_report_attributes(args)
    	find_wage_report_template
      populate_wage_entries
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

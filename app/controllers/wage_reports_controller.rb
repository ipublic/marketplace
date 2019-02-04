class WageReportsController <  ApplicationController
  layout 'two_column'
  before_action :authenticate_user!

  def index
    @organization = Parties::OrganizationParty.find(params[:employer_id])
    @all_quarters = Timespans::Timespan.all_quarters
    @current_quarters = Timespans::Timespan.current_quarters
    @latest_timespan = Wages::WageReport.find_and_filter_wage_reports(@organization)[1].timespan
    @current_timespan =  Timespans::Timespan.current_timespan
    @current_reports =  Wages::WageReport.find_and_filter_wage_reports_by_quarter(@organization,@latest_timespan)
    @report= Wages::WageReport.new
    @org_reports =  Wages::WageReport.find_and_filter_wage_reports(@organization)[2..5] || []
    @last_year_totals = Wages::WageReport.multi_report_totals(@org_reports)
  end

  def new
    @report = Wages::WageReport.new 
    @organization = Parties::OrganizationParty.find(params[:employer_id])
    if params[:report] == "new"
      Wages::WageReportFactory.set_current_report(nil)
    end
    @current_report = Wages::WageReportFactory.get_current_report
    @entries = @current_report.try(:wage_entries)
  end

  def show 
    @current_report = Wages::WageReport.find(params[:id])
    @organization = @current_report.organization_party
    @entries = @current_report.wage_entries.compact
    @entry  =  @current_report.wage_entries.new
    @people = Parties::PersonParty.all
  end

  def edit 
    @report = Wages::WageReport.find(params[:id])
    @organization = @report.organization_party
    @amend_reasons = Wages::WageEntry::AMEND_REASONS

    @entries = @report.wage_entries.sort{|a,b|b.wage.state_total_gross_wages - a.wage.state_total_gross_wages}
    @entry  =  @report.wage_entries.new
    @submission_kinds = Wages::WageEntry::SUBMISSION_KINDS
  end

  def create 
    @report = Wages::WageReport.new
    if params[:commit] == "Add Entry"
      Wages::WageReportFactory.create_report_and_add_entries(params)
    end
    @organization = Parties::OrganizationParty.find(params[:employer_id])
    redirect_to new_employer_wage_report_path(@organization)
  end

  def destroy
    report = Wages::WageReport.find(params[:id])
    entry = report.wage_entries.find(params[:entry])
    entry.destroy 
    redirect_to edit_wage_report_path(report)
  end

  def update
    @report = Wages::WageReport.find(params[:id])
    if params[:commit] == "Cancel" ||  params[:commit] == "Save"
      redirect_to employer_wage_reports_path(@report.organization_party)
    else
      Wages::WageReportFactory.amend(@report, params)
      redirect_to employer_wage_reports_path(@report.organization_party)
    end
  end
end

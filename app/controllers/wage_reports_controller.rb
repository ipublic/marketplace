require 'pry'
class WageReportsController <  ApplicationController
  layout 'two_column'
  before_action :authenticate_user!

  def index
    @organization = Parties::OrganizationParty.find(params[:employer_id])
    @all_quarters = @organization.wage_reports.map(&:timespan).flatten.uniq.sort{|a,b| b.begin_on - a.begin_on}
    @current_reports =  Wages::WageReport.find_and_filter_wage_reports_by_quarter(@organization, @all_quarters.first)
    @report= Wages::WageReport.new
    @org_reports =  Wages::WageReport.find_and_filter_wage_reports(@organization)
  end

  def new
    @timespans =  Timespans::Timespan.all.where('quarter' =>{'$in' => [1,2,3,4]})
    @report = Wages::WageReport.new 
    @organization = Parties::OrganizationParty.find(params[:employer_id])
    @current_report = Wages::WageReportFactory.get_current_report
    @entries = @current_report.try(:wage_entries)
  end

  def show 
    @report = Wages::WageReport.find(params[:id])
    @organization = @report.organization_party
    @entries = @report.wage_entries.sort{|a,b|b.wage.state_total_gross_wages - a.wage.state_total_gross_wages}
    @entry  =  @report.wage_entries.new
    @people = Parties::PersonParty.all
  end

  def edit 
    @report = Wages::WageReport.find(params[:id])
    @organization = @report.organization_party
    # binding.pry binding.
    @entries = @report.wage_entries.sort{|a,b|b.wage.state_total_gross_wages - a.wage.state_total_gross_wages}
    @entry  =  @report.wage_entries.new
    @submission_kinds = Wages::WageEntry::SUBMISSION_KINDS
  end

  def create 
    if params[:commit] == "Add Entry"
      report =  Wages::WageReport.find(params[:wages_wage_report][:report_id]) 
      Wages::WageReportFactory.add_entries(report, params)
    else 
      Wages::WageReportFactory.create_report(params)
    end

    @report = Wages::WageReport.new
    @organization = Parties::OrganizationParty.find(params[:employer_id])
    redirect_to new_employer_wage_report_path(@organization)
  end

  def update
    @report = Wages::WageReport.find(params[:id])
    if params[:commit] == "Cancel" ||  params[:commit] == "Save"
      redirect_to edit_wage_report_path(@report)
    else
      Wages::WageReportFactory.amend(@report, params)
      redirect_to employer_wage_reports_path(@report.organization_party)
    end
  end
end

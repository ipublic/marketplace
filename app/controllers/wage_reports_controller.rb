
require 'pry'
class WageReportsController <  ApplicationController
  layout 'two_column'
  before_action :authenticate_user!
  
  def index
    @organization = Parties::OrganizationParty.find(params[:employer_id])
        
    @all_quarters = @organization.wage_reports.map(&:timespans).flatten.uniq.sort{|a,b| b.begin_on - a.begin_on}
    @current_report =  Wages::WageReport.latest(@organization)
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
    # binding.pry
    @entries = @report.wage_entries.sort{|a,b|b.wage.state_total_gross_wages - a.wage.state_total_gross_wages}
    @entry  =  @report.wage_entries.new
    @submission_kinds = Wages::WageEntry::SUBMISSION_KINDS
  end

  def create 
    @report = Wages::WageReport.new
    @organization = Parties::OrganizationParty.find(params[:employer_id])
  end


  def update
    if params[:commit] == "Cancel" ||  params[:commit] == "Save"
      redirect_to edit_wage_report_path(@report)
    else
      @report = Wages::WageReport.find(params[:id])
      @report.clone_report
      @report.update_entries(params)
      redirect_to wage_report_path(@report)
    end
  end
end

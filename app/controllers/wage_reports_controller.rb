
class WageReportsController <  ApplicationController
  layout 'two_column'
  before_action :authenticate_user!
  
  def index
    @organization = Parties::OrganizationParty.find(params[:employer_id])
    # binding.pry
    @all_quarters = @organization.wage_reports.map(&:timespans).flatten.uniq.sort{|a,b| b.begin_on - a.begin_on}
  end
  
  def show 
    @report = Wages::WageReport.find(params[:id])
    @organization = @report.organization_party
    # binding.pry
    @entries = @report.wage_entries.sort{|a,b|b.wage.state_total_gross_wages - a.wage.state_total_gross_wages}
    @entry  =  @report.wage_entries.new
    @people = Parties::PersonParty.all

  end

  def create 
    @report = Wages::WageReport.new
    @organization = Parties::OrganizationParty.find(params[:employer_id])
    require 'pry';
    # binding.pry
  end

  def update
    wage_params = params[:wages_wage_report][:wage]
    @report = Wages::WageReport.find(params[:id]) 
    @people = Parties::PersonParty.all
    person = Parties::PersonParty.find(params[:people])
    @wage =  Wages::Wage.new(
      person_party: person,
      timespan: @report.timespan,
      state_total_gross_wages: wage_params["state_total_gross_wages"],
      state_total_wages: wage_params["state_total_wages"],
      state_excess_wages: wage_params["state_excess_wages"],
      state_taxable_wages: wage_params["state_taxable_wages"]
    )
    entry = @report.wage_entries.new(submission_kind: :ammended, wage:@wage)
    require 'pry';
     binding.pry

  end
end

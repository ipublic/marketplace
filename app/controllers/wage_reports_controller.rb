
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
   @entries = @report.wage_entries
  end
end

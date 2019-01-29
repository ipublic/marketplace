
class WageReportsController <  ApplicationController
  layout 'two_column'
  before_action :authenticate_user!
  
  def index
    organization = Parties::OrganizationParty.find(params[:organization_party_id])
    @reports = organization.wage_reports
  end
  
  def show 
   @report = Wages::WageReport.find(params[:id])
  end
end

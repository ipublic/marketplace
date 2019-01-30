
class WageEntriesController <  ApplicationController
  layout 'two_column'
  before_action :authenticate_user!
  
  def index
    @organization = Parties::OrganizationParty.find(params[:employer_id])
    # binding.pry
    @all_quarters = @organization.wage_reports.map(&:timespans).flatten.uniq.sort{|a,b| b.begin_on - a.begin_on}
  end
  
  def show 

  end

  def create 
    require 'pry';
    binding.pry
    @report = Wages::WageReport.find(params[:id]) 
    @report.wage_entries.create(params)

    # @organization = Parties::OrganizationParty.find(params[:employer_id])
  end
  
  def update 
    @report = Wages::WageReport.find(params[:id]) 
   wage =  Wages::Wage.new
    entry = @report.wage_entries.new(submission_kind: :ammended)
    require 'pry';
     binding.pry
  end

end

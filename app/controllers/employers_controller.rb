class EmployersController < ApplicationController
  layout 'two_column'
  before_action :authenticate_user!

  def index
  end

  def new
    @employer = Employers::EmployerForm.for_new
  end

  def get_employers
    @orgs = Parties::OrganizationParty.all
    render json: { data: @orgs }
  end

  def create
    @employer = Employers::EmployerForm.for_create(params.permit[:address_info,
                                                                 :contact_info,
                                                                 :contribution_info,
                                                                 :employer_info])
    @employer.save
  end
end

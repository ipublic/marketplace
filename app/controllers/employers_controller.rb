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
    @employer = Employers::EmployerForm.for_create({form_params.to_json})
    if @employer.save
			render json: {code: 200, message: 'Employer Registration successfully submitted.'}
		else
			render json: {code: 400, message: 'Unable to process this request.'}
		end
  end

	private

	def form_params
		params.permit(:contact_info, :employer_info, :address_info)
	end
end

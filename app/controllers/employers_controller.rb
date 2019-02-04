class EmployersController < ApplicationController
  layout 'two_column', except: [:new]
  before_action :authenticate_user!

  def index
  end

  def new
    @employer = Employers::EmployerForm.for_new
  end

  def get_employers
    @orgs = Parties::OrganizationParty.all.order(created_at: :desc)
    render json: { data: @orgs }
  end

  def create
    @employer = Employers::EmployerForm.for_create(contact_info: JSON.parse(form_params[:contact_info]), employer_info: JSON.parse(form_params[:employer_info]), address_info: JSON.parse(form_params[:address_info]))
    if @employer.save
			render json: {code: 200, message: 'Employer Registration successfully submitted.'}
		else
			render json: {code: 400, message: 'Unable to process this request.'}
		end
  end

	private

	def form_params
		params.require(:employer).permit(:address_info, :contact_info, :employer_info)
	end
end

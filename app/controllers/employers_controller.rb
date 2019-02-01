class EmployersController < ApplicationController
  layout 'two_column'
  before_action :authenticate_user!

  def index
  end

  def new
  end

  def create
    @employer = Employers::EmployerForm.for_create(params.permit[:address_info,
                                                                 :contact_info,
                                                                 :contribution_info,
                                                                 :employer_info])
    @employer.save
  end
end

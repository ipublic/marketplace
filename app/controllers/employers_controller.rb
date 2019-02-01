class EmployersController < ApplicationController
  layout 'two_column'
  before_action :authenticate_user!

  def index
  end

  def new
  end

  def create
  end

  def get_employers
    @orgs = Parties::OrganizationParty.all
    render json: { data: @orgs }
  end
end

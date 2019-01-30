class EmployersController < ApplicationController
  layout 'two_column'
  before_action :authenticate_user!

  def index
  end

  def new
  end
end

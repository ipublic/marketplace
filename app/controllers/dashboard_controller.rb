class DashboardController < ApplicationController
  layout 'two_column'
  before_action :authenticate_user!
  
  def index
  end
end

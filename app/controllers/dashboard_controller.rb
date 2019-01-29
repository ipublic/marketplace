class DashboardController < ApplicationController
  layout 'two_column'
  before_action :authenticate_user!
  
  def index
    require 'pry';
    binding.pry
  end
end

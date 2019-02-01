class PagesController < ApplicationController
  layout 'two_column'
  before_action :authenticate_user!

  def home   
  end
end

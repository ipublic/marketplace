class PagesController < ApplicationController
  layout 'two_column'
  before_action :authenticate_user!

  def home   
    require 'pry';
    binding.pry
  end
end

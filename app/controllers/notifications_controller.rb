class NotificationsController < ApplicationController
  layout 'two_column'
  before_action :authenticate_user!
  
end

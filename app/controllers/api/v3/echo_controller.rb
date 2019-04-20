class Api::V3::EchoController < ApplicationController
  before_action :shout_out

  def show
    # render json: @echo 
  end

  private

  def shout_out
    @echo = 
      {
        id: 54321,
        message: "Hello World!",
      }
  end
end

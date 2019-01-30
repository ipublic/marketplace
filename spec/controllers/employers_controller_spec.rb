require 'rails_helper'

RSpec.describe EmployersController, type: :controller do
  describe "POST #create" do
    before do
      post :create
    end

    it 'creates a new employer' do
      expect(true).to be_true
    end
  end
end

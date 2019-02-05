class AccountsController < ApplicationController
  layout 'two_column'
  before_action :authenticate_user!


  def index
    @organization = Parties::OrganizationParty.find(params[:employer_id])
    @account = @organization.party_ledger.financial_accounts.last
    @transactions = @account.financial_transactions
  end
end

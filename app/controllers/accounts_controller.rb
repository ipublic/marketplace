class AccountsController < ApplicationController

  def show
    @organization = Parties::OrganizationParty.find(params[:employer_id])
    @account = @organization.party_ledger.financial_accounts.last
    @transactions = @account.financial_transactions
  end
end

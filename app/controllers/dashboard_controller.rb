class DashboardController < ApplicationController
  layout 'two_column'
  before_action :authenticate_user!

  def index
    @employers = Parties::OrganizationParty.limit(6)
    @tpas = []
    Parties::Party.each do |party|
      if party.present?
        kind = party.party_roles.first
        if kind.present?
          if kind.party_role_kind.key == :tpa
            @tpas << party
          end
        end
      end
    end
  end
end

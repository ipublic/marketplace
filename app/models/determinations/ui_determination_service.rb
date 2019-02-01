module Determinations
	class UiDeterminationService

    attr_accessor :organization_party

    def initialize(organization_party: nil)
      @organization_party = organization_party
    end

    def add_employer
    end

    def determine_contribution_rate
    end

    def determine_write_off_eligibility
    end

    def add_ui_acccount
    	ledger = build_or_find_party_ledger

    	ui_account = FinancialAccounts::UiFinancialAccount.new(	title: "#{@organization_party.legal_name}'s Unemployment Insurance Account",
    																													initial_liability_date: TimeKeeper.date_of_record.beginning_of_quarter,
    																													# current_payment_type: @organization_party., 
    																													# current_wage_filing_schedule: ,
    																													)
    end

    def current_payment_model

    #   contributing_role = Parties::PartyRole.find_by(key: :uits_contributing)
    #   reimbursing_role = Parties::PartyRole.find_by(key: :uits_reimbursing)

    #   [contributing_role, reimbursing_role].map { |role| }

    #   if @organization.active_party_roles_by_key(contributing_role)
    #   	contributing_role
    #   elsif 
    #   	els
  		# end
    end

    def current_filing_schedule
    	quarterly_filer_role = Parties::PartyRole.find_by(key: :uits_qtr_filer)
      annual_filer_role = Parties::PartyRole.find_by(key: :uits_annual_filer)
    end

    def build_or_find_party_ledger
    	@organization_party.party_ledger.present? ? ledger = @organization_party.party_ledger : @organization_party.build_party_ledger
    end

    def add_case
    end

    def close_case
    end

	end
end

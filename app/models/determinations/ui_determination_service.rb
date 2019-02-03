module Determinations
	class UiDeterminationService

    attr_accessor :organization_party

    def initialize(organization_party: nil)
      @organization_party = organization_party
    end

    def add_employer

    	@organization_party.add_role 
    end

    def determine_contribution_rate
    	# [:non_profit_501c3, :other_non_profit].detect { |non_profit_role| }
    	# if @organization_party.active_party_roles_by_key(:non_profit_501c3) || 

    	current_rate_range 				= 0.016..7.0
    	new_employer_rate 				= 0.027
    	reimbursing_employer_rate = 0.0
    	
    	new_employer_rate
    end

    def determine_administrative_rate
    	0.002
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

    def determine_payment_model
    #   contributing_role = Parties::PartyRole.find_by(key: :uits_contributing)
    #   reimbursing_role = Parties::PartyRole.find_by(key: :uits_reimbursing)

    #   [contributing_role, reimbursing_role].map { |role| }

    #   if @organization.active_party_roles_by_key(contributing_role)
    #   	contributing_role
    #   elsif 
    #   	els
  		# end
    end

    def determine_filing_schedule
    	if @organization_party.party_active_roles_by_key(:household_employer).size > 0
    		Parties::PartyRole.find_by(key: :uits_annual_filer)
    	else
    		Parties::PartyRole.find_by(key: :uits_qtr_filer)
    	end
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

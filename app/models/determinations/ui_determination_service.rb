module Determinations
	class UiDeterminationService
    include ActiveSupport::Configurable

    attr_accessor :party

    def initialize(party: nil)
      @party = party
      @active_role_keys = @party.active_party_role_keys
    end

    def initial_liability_date
      #TODO get this date from Employer registration: date wages first paid
      TimeKeeper.date_of_record
    end

    def payment_kind
      # if @active_role_keys.include?(:non_profit_501c3) || @active_role_keys.include?(:other_non_profit)
      # end

      @active_role_keys.include?(:uits_reimbursing) ? :uits_reimbursing : :uits_contributing
    end

    def wage_filing_schedule
      @active_role_keys.include?(:household_employer) ? :uits_annual_filer : :uits_qtr_filer
    end

    def administrative_rate
      0.002
    end

    def contribution_rate
      new_employer_rate          = 0.027
    	current_rate_range         = 0.016..7.0
    	reimbursing_employer_rate  = 0.0
    	
    	new_employer_rate
    end

    def write_off_eligibility
    end

    def add_ui_acccount
    	@ledger = build_or_find_party_ledger
      title = "#{@party.legal_name}'s Unemployment Insurance Account"
      initial_liability_date = TimeKeeper.date_of_record.beginning_of_quarter

    	@ui_account = FinancialAccounts::UiFinancialAccount.new(title: title,
      																												initial_liability_date: initial_liability_date,
      																												# current_payment_type: @party., 
      																												# current_wage_filing_schedule: ,
    																												)
    end

	end
end

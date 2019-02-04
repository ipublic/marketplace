module FinancialAccounts
  class FinancialAccountFactory

		UI_FINANCIAL_ACCOUNT_KIND 	= :ui_financial_account
		PFL_FINANCIAL_ACCOUNT_KIND 	= :pfl_financial_account

		attr_accessor :financial_account

    def self.call(party, args)
      build(party, args).financial_account
    end

    def initialize(party, args)
    	@party							= party
    	@account_kind 			= args[:account_kind]

    	@ledger	= nil
    	@financial_account	= nil
    	@determination_service = nil

    	build_or_find_party_ledger

    	initialize_determination_service
    	build_or_find_ui_financial_account if @account_kind == UI_FINANCIAL_ACCOUNT_KIND
    end

    def build_or_find_party_ledger
    	if @party.party_ledger.present?
    		@ledger = @party.party_ledger
    	else
    		@ledger = @party.build_party_ledger
    	end
    end

    def initialize_determination_service
    	@determination_service = Determinations::UiDeterminationService.new(@party)
    end

    def build_or_find_ui_financial_account
			if @ledger.ui_financial_account.present?
				@financial_account = @ledger.ui_financial_account
			else
				@financial_account = build_ui_financial_account
			end
    end

    def build_ui_financial_account
      title = "#{@party.legal_name}'s Unemployment Insurance Account"
      opened_on = TimeKeeper.date_of_record
      @ledger.build_ui_financial_account(title: title, opened_on: opened_on)
      initialize_ui_financial_account
    end

    def initialize_ui_financial_account
    	@financial_account.initial_liability_date 			= @determination_service.initial_liability_date(@party)
    	@financial_account.current_payment_kind 				= @determination_service.current_payment_kind(@party)
    	@financial_account.current_wage_filing_schedule = @determination_service.current_wage_filing_schedule(@party)
    	@financial_account.current_administrative_rate 	= @determination_service.current_administrative_rate(@party)
    	@financial_account.current_contribution_rate 		= @determination_service.current_contribution_rate(@party)

    	@financial_account.transactions << initial_transaction
    end

    def initial_transaction
    	title = opening_balance
    	kind = :credit
    	amount = 0.0
    	FinancialAccountTransaction.new(title: title, kind: kind, amount: amount)
    end

    def financial_account
    	@financial_account.transactions << opening_balance_transaction
    end

  end
end

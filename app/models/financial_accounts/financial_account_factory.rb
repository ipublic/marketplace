module FinancialAccounts
  class FinancialAccountFactory

		UI_FINANCIAL_ACCOUNT_KIND 	= :ui_financial_account
		PFL_FINANCIAL_ACCOUNT_KIND 	= :pfl_financial_account

		attr_accessor :financial_account

    def self.call(party, args)
      new(party, args).financial_account
    end

    def initialize(party, args)
    	@party							= party
    	@account_kind 			= args[:account_kind]
      @initial_liability_date = args[:initial_liability_date]

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
    	@determination_service = Determinations::UiDeterminationService.new(party: @party)
    end

    def build_or_find_ui_financial_account
			if @ledger.financial_accounts.present?
				@financial_account = @ledger.ui_financial_account
			else
				@financial_account = build_ui_financial_account
        initialize_ui_financial_account
			end
    end

    def build_ui_financial_account
      title = "#{@party.legal_name}'s Unemployment Insurance Account"
      opened_on = TimeKeeper.date_of_record
      FinancialAccounts::UiFinancialAccount.new(party_ledger: @ledger, title: title, opened_on: opened_on)
    end

    def initialize_ui_financial_account
    	@financial_account.initial_liability_date 			= @determination_service.initial_liability_date
    	@financial_account.current_payment_kind 				= @determination_service.payment_kind
    	@financial_account.current_wage_filing_schedule = @determination_service.wage_filing_schedule
    	@financial_account.current_administrative_rate 	= @determination_service.administrative_rate
    	@financial_account.current_contribution_rate 		= @determination_service.contribution_rate

    	@financial_account.financial_transactions << initial_transaction
    end

    def initial_transaction
    	title = 'opening balance'
    	kind = :credit
    	amount = 0.0
    	::FinancialAccounts::FinancialTransaction.new(title: title, kind: kind, amount: amount)
    end
  end
end

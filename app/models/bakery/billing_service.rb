module Bakery
  class BillingService

    def call(**options)
      new(**options).statement
    end

    def initialize(**options)
      @product = options[:product]
      @customer = options[:customer]

      @product_price = calculate_price
      # update_customer_account
      @statement = generate_statement

      self
    end

    def calculate_price
      SellCupcakeJob.perform_later
      # BillingServiceJob.perform_now
    end

    def update_customer_account
    end

    def generate_statement
      @statement = "statement object TBD"
    end

    def statement
      @statement
    end

  end
end

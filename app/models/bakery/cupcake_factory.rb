module Bakery
  class CupcakeFactory

    def self.call(**options)
      new(options).cupcake
    end

    def initialize(**options)
      @cupcake = Bakery::Cupcake.new
      @cupcake.cc_id = options[:cc_id] if options[:cc_id].present?

      bake_cupcake
      frost_cupcake
      add_sprinkles

      self
    end

    def bake_cupcake
      @cupcake.cake = Bakery::Cupcake::CAKE_KINDS.sample
    end

    def frost_cupcake
      @cupcake.frosting = Bakery::Cupcake::FROSTING_KINDS.sample
    end

    def add_sprinkles(shake_count = 2)
      count = 0
      while count < shake_count
        @cupcake.sprinkles << Bakery::Sprinkle.new().sample_sprinkle
        count += 1
      end
    end

    def cupcake
      @cupcake
    end

  end
end

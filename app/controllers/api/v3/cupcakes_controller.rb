module Api::V3
  class CupcakesController < ApplicationController
    # before_action :bake_cupcakes

    def index
      cupcake_count = 50_000
      @sprinkles = make_sprinkles
      @cupcakes = bake_cupcakes(cupcake_count)

      options = {}
      options[:is_collection]
      # options[:include] = [:sprinkle]
      options[:meta] = { total: cupcake_count }

      serializer = CupcakeSerializer.new(@cupcakes, options)
      render json: serializer.serialized_json
      # render json: serializer.serializable_hash
    end

    private

    def bake_cupcakes(count = 1)
      cupcakes = []
      id = 0
      count.times do |id|
        cupcake               = Cupcake.new
        cupcake.id            = id
        cupcake.cake          = Cupcake::CAKE_KINDS.sample
        cupcake.frosting      = Cupcake::FROSTING_KINDS.sample
        cupcake.sprinkle_ids  = [@sprinkles.sample.id]
        cupcake.created_at    = Time.now
        id += 1
        
        cupcakes << cupcake
      end

      cupcakes
    end

    def make_sprinkles
      [0,1,2,3,4].reduce([]) do |list, id|
        sprinkle = Sprinkle.new
        sprinkle.id = id
        sprinkle.color = Sprinkle::COLOR_KINDS.sample
        sprinkle.shape = Sprinkle::SHAPE_KINDS.sample
        list << sprinkle
      end
    end
  end

  class Cupcake
    attr_accessor :id, :cake, :frosting, :created_at, :sprinkle_ids

    CAKE_KINDS      = %w[ white chocolate yellow  ].freeze
    FROSTING_KINDS  = %w[ vanilla chocolate strawberry banana grape cherry coconut ].freeze

    def initialize
      @sprinkle_ids = []
    end
  end

  class Sprinkle
    attr_accessor :id, :color, :shape

    COLOR_KINDS = %w[ red white blue yellow green pink orange purple black ].freeze
    SHAPE_KINDS = %w( star circle diamond square hexagon ).freeze
  end
end

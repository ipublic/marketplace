module Api::V3
  class CupcakesController < ApplicationController
    # before_action :bake_cupcakes

    def index
      @view_size = 20
      @view_number ||= 1
      @page_number = @view_number + 1
      @offset = (@view_number * @view_size)

      @cupcake_count = Bakery::Cupcake.all.size
      @cupcakes = Bakery::Cupcake.all.order_by_cc_id.view_window(@offset, @view_size)

      options = {}
      options[is_collection: true]
      options[:meta] = { 
                          view_size: @view_size, 
                          view_number: @view_number, 
                          page_number: @page_number, 
                          total: @cupcake_count 
                        }

      serializer = CupcakeSerializer.new(@cupcakes, options)
      render json: serializer.serialized_json
      # render json: serializer.serializable_hash
    end

    private

  end
end

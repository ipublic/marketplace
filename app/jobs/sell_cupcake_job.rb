class SellCupcakeJob < ApplicationJob
  queue_as :default

  def perform(cupcakes = [])

    json_api_opts = {}
    json_api_opts[is_collection: true]
    json_api_opts[:meta] = {total: cupcakes.length }

    serializer = CupcakeSerializer.new(cupcakes, json_api_opts)
    message = serializer.serialized_json

    ActiveJob::Base.execute message
    ack!

  end
end

class CupcakeSerializer
  include FastJsonapi::ObjectSerializer

  attributes :cc_id, :cake, :frosting, :sprinkles, :created_at, :updated_at
  # has_many :sprinkles, serializer: :sprinkle_serializer

  # attribute :time_stamp do |object|
  #   Time.now
  # end
  
end

class CupcakeSerializer
  include FastJsonapi::ObjectSerializer

  attributes :cake, :frosting, :time_stamp
  has_many :sprinkles, serializer: :sprinkle_serializer

  attribute :time_stamp do |object|
    Time.now
  end
  
end

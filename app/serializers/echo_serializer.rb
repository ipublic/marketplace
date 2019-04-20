class EchoSerializer # < ActiveModel::Serializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :message, :time_stamp

  attribute :time_stamp do |object|
    Time.now
  end
  
end

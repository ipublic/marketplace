class Address
  include Mongoid::Document
  include Mongoid::Timestamps

  KINDS = %W(home work mailing)
  OFFICE_KINDS = %W(primary mailing branch)

  embedded_in :addressable, polymorphic: true

  field :kind, type: String

  field :address_1, type: String
  field :address_2, type: String, default: ""

  # The name of the city where this address is located
  field :city, type: String

  # The name of the county where this address is located
  field :county, type: String, default: ''

  # The name of the U.S. state where this address is located
  field :state, type: String

  # The postal zip code where this address is located
  field :zip, type: String
end

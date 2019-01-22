class Parties::PartyRole
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :party,
  						class_name: "Parties:Party"

  # Begin date for this party_role 
  field :start_date, type: Date

  # End date for this party_role
  field :end_date, type: Date

  field :party_role_kind_id, type: BSON::ObjectId

  delegate :kind,					to: :party_role_kind, allow_nil: false
  delegate :title, 				to: :party_role_kind, allow_nil: false
  delegate :description, 	to: :party_role_kind, allow_nil: true

  def party_role_kind=(new_party_role)
  end

  def party_role_kind
  end

end

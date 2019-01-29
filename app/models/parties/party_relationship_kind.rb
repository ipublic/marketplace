class Parties::PartyRelationshipKind
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :party_relationship,
  						class_name: "Parties::PartyRelationship"

  field :party_role_kind,	type: String
  field :kind,						type: String
  field :name,						type: String
  field :description,			type: String

  # embeds_many :party_roles, as: :role_castable
  # embeds_many :comments, as: :commentable, cascade_callbacks: true

  
end

module Parties
  class PartyRelationshipKind
    include Mongoid::Document
    include Mongoid::Timestamps

    # embedded_in :party_relationship,
    # 						class_name: "Parties::PartyRelationship"

    field :key,                         type: Symbol
    field :title,						            type: String
    field :description,			            type: String
    # field :role_kinds,                  type: Array, default: []

    has_and_belongs_to_many  :party_role_kinds,
              class_name: 'Parties::PartyRoleKind'

    validates_presence_of :key, :title

    validate :role_kinds_set


    # embeds_many :party_roles, as: :role_castable
    # embeds_many :comments, as: :commentable, cascade_callbacks: true

    private

    def role_kinds_set
      party_role_kinds.size == 2
    end

  end
end

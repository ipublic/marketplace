module Parties
  class PartyRelationshipKind
    include Mongoid::Document
    include Mongoid::Timestamps

    field :key,                         type: Symbol
    field :title,						            type: String
    field :description,			            type: String

    has_and_belongs_to_many  :party_role_kinds,
              class_name: 'Parties::PartyRoleKind'

    # Associate a business rule for validating a role instance
    # belongs_to              :eligibility_policy,
    #                         class_name: 'EligibilityPolicies::EligibilityPolicy'

    # embeds_many :party_roles, as: :role_castable
    # embeds_many :comments, as: :commentable, cascade_callbacks: true

    validates_presence_of :key, :title

    # before_validation :assign_key_and_title

    def key=(new_key)
      write_attribute(:key, text_to_symbol(new_key))
    end

    private

    def assign_key_and_title
      write_attribute(:key, text_to_symbol(title)) if key.blank? && title.present?
      write_attribute(:title, symbol_to_text(title)) if title.blank? && key.present?
    end

    def text_to_symbol(text)
      text.to_s.underscore.to_sym
    end

    def symbol_to_text(symbol)
      symbol.to_s.titleize
    end

  end
end

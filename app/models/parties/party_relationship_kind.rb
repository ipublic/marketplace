module Parties
  class PartyRelationshipKind
    include Mongoid::Document
    include Mongoid::Timestamps

    field :key,               type: Symbol
    field :title,             type: String
    field :description,       type: String

    # List of PartyRoleKind roles that can be played between the Party pair
    has_and_belongs_to_many   :party_role_kinds,
                              class_name: 'Parties::PartyRoleKind'

    # Optional business rules for validating a relationship instance
    has_one                   :eligibility_policy,
                              class_name: 'EligibilityPolicies::EligibilityPolicy'

    # embeds_many               :comments, as: :commentable


    validates_presence_of :key, :title
    validate :party_role_kind_pairing

    before_validation :assign_key_and_title

    private

    def assign_key_and_title
      write_attribute(:key, text_to_symbol(title)) if key.blank? && title.present?
      write_attribute(:title, symbol_to_text(key)) if title.blank? && key.present?
    end

    def text_to_symbol(text)
      text.to_s.parameterize.underscore.to_sym
    end

    def symbol_to_text(symbol)
      symbol.to_s.titleize
    end

    # Logic to validate subject_party_role_kind => object_party_role_kind pairing
    def party_role_kind_pairing
      errors.add(:party_role_kinds, "must provide a specific role pair") unless party_role_kinds.size == 2

    end

  end
end

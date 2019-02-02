module Parties
  class PartyRelationship
    include Mongoid::Document
    include Mongoid::Timestamps

    # embedded_in :party_role,
    # 						class_name: "Parties::PartyRole"

    belongs_to  :party_relationship_kind,
                class_name: 'Parties::PartyRelationshipKind'

    has_many    :party_roles,
                class_name: 'Parties::PartyRole'


    # field :related_party_id,            type: BSON::ObjectId
    # field :party_relationship_kind_id,  type: BSON::ObjectId

    # Begin date for this relationship
    field :start_date,                  type: Date, default: ->{ TimeKeeper.date_of_record }

    # End date for this relationship
    field :end_date,                    type: Date

    # embeds_one  :party_relationship_kind,
    #             class_name: "Parties::PartyRelationshipKind"

    delegate :key,                  to: :party_relationship_kind
    delegate :title,                to: :party_relationship_kind
    delegate :description,          to: :party_relationship_kind
    delegate :party_relationships,  to: :party_relationship_kind
      # delegate :eligibility_policy,         to: :party_role_kind, allow_nil: true

    # validates_presence_of  :party_relationship_kind_id, :related_party_id
    validate :party_role_pairing
    validates_presence_of  :party_relationship_kind

    def is_active?
      end_date.blank? || end_date > TimeKeeper.date_of_record
    end

    # def related_party=(new_related_party)
    #     if new_related_party.nil?
    #       write_attribute(:related_party_id, nil)
    #     else
    #       raise ArgumentError.new("expected Parties::Party") unless new_related_party.is_a? Partys::BenefitApplication
    #       write_attribute(:related_party_id, new_related_party._id)
    #     end
    #     @related_party = new_related_party
    # end

    # def related_party
    #   return nil if related_party_id.blank?
    #   return @related_party if defined? @related_party
    #   @related_party = benefit_sponsorship.benefit_applications_by(related_party_id)
    # end

    # def party_relationship_kind=(new_party_relationship_kind)
    #     if new_party_relationship_kind.nil?
    #       write_attribute(:party_relationship_kind_id, nil)
    #     else
    #       raise ArgumentError.new("expected Parties:PartyRelationshipKind") unless new_party_relationship_kind.is_a? Parties:PartyRelationshipKind
    #       write_attribute(:party_relationship_kind_id, new_party_relationship_kind._id)
    #     end
    #     @party_relationship_kind = new_party_relationship_kind
    # end

    # def party_relationship_kind
    #   return nil if party_relationship_kind_id.blank?
    #   return @party_relationship_kind if defined? @party_relationship_kind
    #   @party_relationship_kind = Parties:PartyRelationshipKind.find(party_relationship_kind_id)
    # end

    private

    def party_role_pairing
      errors.add(:party_roles, "must provide a specific role pair") unless party_roles.size == 2

    end


  end
end

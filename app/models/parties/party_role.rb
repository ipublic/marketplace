# A Person or Organization may play different roles on the system.  Roles may be used for different purposes, including:
# 	* storing different infomrmation about a Party
# 	* defining authorization/access privilidges 
# 
# This class manages roles assigned to instances.  A Role may be declarative, 
module Parties
  class PartyRole
    include Mongoid::Document
    include Mongoid::Timestamps

    embedded_in :party,
      					class_name: "Parties:Party"

    field :party_role_kind_id, 	type: BSON::ObjectId
    field :related_party_id, 		type: BSON::ObjectId

    # Date this role becomes effective for subject party
    field :start_date, 					type: Date, default: ->{ TimeKeeper.date_of_record }

    # Date this rolerole is no longer in effect for subject_party
    field :end_date, 						type: Date

    validates_presence_of :party_role_kind_id, :start_date
    validate :validate_related_party

    delegate :key, 												to: :party_role_kind, allow_nil: true
    delegate :title, 											to: :party_role_kind, allow_nil: true
    delegate :description, 								to: :party_role_kind, allow_nil: true
    delegate :party_relationship_kinds, 	to: :party_role_kind, allow_nil: true
    # delegate :eligibility_policy, 				to: :party_role_kind, allow_nil: true

    def is_active?
      end_date.blank? || end_date > TimeKeeper.date_of_record
    end

    # Deactive this role
    def end_role(new_end_date = TimeKeeper.date_of_record)
    	related_party.end_role(new_end_date)
    	write_attribute(:end_date, new_end_date)
    end

    # Restore a previously deactiviated role
    def reinstate_role
    	related_party.reinstate_role(new_end_date)
    	write_attribute(:end_date, nil)
    end

    def party_role_kind=(new_party_role_kind)
      if new_party_role_kind.nil?
        write_attribute(:new_party_role_kind, nil)
      else
        raise ArgumentError.new("expected Parties::PartyRoleKind") unless new_party_role_kind.is_a? Parties::PartyRoleKind
        write_attribute(:party_role_kind_id, new_party_role_kind._id)
      end
      @party_role_kind = new_party_role_kind
    end

    def party_role_kind
      return nil if party_role_kind_id.blank?
      return @party_role_kind if defined? @party_role_kind
      @party_role_kind = Parties::PartyRoleKind.find(party_role_kind_id)
    end

    # Setter for Party instance associated through this Role
    def related_party=(new_related_party)
      if new_related_party.nil?
        write_attribute(:new_related_party, nil)
      else
        raise ArgumentError.new("expected Parties::Party") unless new_related_party.is_a? Parties::Party
        write_attribute(:related_party_id, new_related_party._id)
      end
      @related_party = new_related_party
    end

    # Getter for Party instance associated through this Role
    def related_party
      return nil if related_party_id.blank?
      return @related_party if defined? @related_party
      @related_party = Parties::Party.find(related_party_id)
    end

    private

    def validate_related_party
      if party_relationship_kinds.present?

        errors.add(:related_party, "party_role #{title} requires a related party instance") if related_party.blank?
        errors.add(:related_party, "party_role #{title} related party kinds #{party_relationship_kinds.inspect} don't match party_relationship definition") unless party_roles_match?
      else
        errors.add(:related_party, "unexpected related_party #{related_party.inspect} for party_role #{title}") if related_party.present?
      end

    end

    # Party roles must match
    # Compare Roles for this and associated party
    def party_roles_match?
      return false if related_party.blank?

      #TODO Develop validation for valid role-to-role relationship pairing
      true
    end
  end
end

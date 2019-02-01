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



    def create_party_role_kinds

    	## PersonParty Roles ##
      Parties::PartyRoleKind.create!(key: :employee, title: 'Employee')
      Parties::PartyRoleKind.create!(key: :owner_or_officer, title: 'Owner/Officer')
      Parties::PartyRoleKind.create!(key: :contractor, title: 'Contractor')

      Parties::PartyRoleKind.create!(key: :self, title: 'Self')
      Parties::PartyRoleKind.create!(key: :spouse, title: 'Spouse')
      Parties::PartyRoleKind.create!(key: :domestic_partner, title: 'Domestic Partner')
      Parties::PartyRoleKind.create!(key: :child, title: 'Child')
      Parties::PartyRoleKind.create!(key: :dependent, title: 'Dependent')

      Parties::PartyRoleKind.create!(key: :primary_contact, title: 'Primary Contact')
      Parties::PartyRoleKind.create!(key: :secondary_contact, title: 'Secondary Contact')

      # UITS/PFL 
      Parties::PartyRoleKind.create!(key: :tpa_agent, title: 'TPA Agent')
      Parties::PartyRoleKind.create!(key: :ui_claiment, title: 'Unemployment Insurance Claiment')


      ## OrganizationParty Roles ##
      Parties::PartyRoleKind.create!(key: :parent_organization, title: 'Parent Organization')
      Parties::PartyRoleKind.create!(key: :subsiary, title: 'Subsiary')
      Parties::PartyRoleKind.create!(key: :department, title: 'Department')
      Parties::PartyRoleKind.create!(key: :division, title: 'Division')
      Parties::PartyRoleKind.create!(key: :internal_organization, title: 'Internal Organization')
      Parties::PartyRoleKind.create!(key: :other_organization_unit, title: 'Other Organization Unit')
      Parties::PartyRoleKind.create!(key: :employer, title: 'Employer')

    	# Site Owner is super user across system -- only assign to one organization
      Parties::PartyRoleKind.create!(key: :site_owner, title: 'Site Owner')

      # Corporate Entity Kinds
      Parties::PartyRoleKind.create!(key: :s_corporation, title: 'S Corporation')
      Parties::PartyRoleKind.create!(key: :c_corporation, title: 'C Corporation')
      Parties::PartyRoleKind.create!(key: :limited_liability_corporation, title: 'Limited Liability Corporation')
      Parties::PartyRoleKind.create!(key: :limited_liability_partnership, title: 'Limited Liability Partnership')
      Parties::PartyRoleKind.create!(key: :non_profit_501c3, title: 'Non Profit 501c(3) Corporation')
      Parties::PartyRoleKind.create!(key: :other_non_profit, title: 'Other Non Profit')
      Parties::PartyRoleKind.create!(key: :household_employer, title: 'Household Employer')
      Parties::PartyRoleKind.create!(key: :regulatory_agency, title: 'Regulatory Agency')

      # UITS/PFL 
      Parties::PartyRoleKind.create!(key: :tpa, title: 'Third Party Administrator')
      Parties::PartyRoleKind.create!(key: :tpa_agent, title: 'TPA Agent')

      Parties::PartyRoleKind.create!(key: :uits_liable, title: 'Unemployment Insurance Tax Liable')
      Parties::PartyRoleKind.create!(key: :uits_exempt, title: 'Unemployment Insurance Tax Exempt')
      Parties::PartyRoleKind.create!(key: :uits_contributing, title: 'UI Tax Contribution Payment Model')
      Parties::PartyRoleKind.create!(key: :uits_reimbursing, title: 'UI Tax Reimbursement Payment Model')
      Parties::PartyRoleKind.create!(key: :uits_qtr_filer, title: 'UI Tax Quarterly Filer')
      Parties::PartyRoleKind.create!(key: :uits_annual_filer, title: 'UI Tax Annual Filer')

      Parties::PartyRoleKind.create!(key: :pfl_liable, title: 'Paid Family Leave Tax Liable')
      Parties::PartyRoleKind.create!(key: :pfl_exempt, title: 'Paid Family Leave Tax Exempt')
      Parties::PartyRoleKind.create!(key: :pfl_opt_in, title: 'Paid Family Leave Tax Opted-In')

    end

    def create_party_relationship_kinds
      Parties::PartyRelationshipKind.create!(	key: :employment, title: 'Employment',
                                              party_role_kinds: [
	                                                Parties::PartyRoleKind.find_by(key: :employee),
	                                                Parties::PartyRoleKind.find_by(key: :employer),
	                                                Parties::PartyRoleKind.find_by(key: :owner_or_officer),
	                                              ]
                                              )

      Parties::PartyRelationshipKind.create!(	key: :organization_rollup, title: 'Organization Contact',
                                              party_role_kinds: [
	                                                Parties::PartyRoleKind.find_by(key: :primary_contact),
	                                                Parties::PartyRoleKind.find_by(key: :secondary_contact),
	                                              ]
                                              )

      Parties::PartyRelationshipKind.create!(	key: :organization_entity, title: 'Organization Entity',
                                              party_role_kinds: [
	                                                Parties::PartyRoleKind.find_by(key: :parent_organization),
	                                                Parties::PartyRoleKind.find_by(key: :subsiary),
	                                                Parties::PartyRoleKind.find_by(key: :department),
	                                                Parties::PartyRoleKind.find_by(key: :division),
	                                                Parties::PartyRoleKind.find_by(key: :other_organization_unit),
	                                              ]
                                              )


      Parties::PartyRelationshipKind.create!(	key: :organization_rollup, title: 'Organization Rollup',
                                              party_role_kinds: [
	                                                Parties::PartyRoleKind.find_by(key: :parent_organization),
	                                                Parties::PartyRoleKind.find_by(key: :subsiary),
	                                                Parties::PartyRoleKind.find_by(key: :department),
	                                                Parties::PartyRoleKind.find_by(key: :division),
	                                                Parties::PartyRoleKind.find_by(key: :other_organization_unit),
	                                              ]
                                              )

      Parties::PartyRelationshipKind.create!(	key: :family_rollup, title: 'Family Rollup',
                                              party_role_kinds: [
	                                                Parties::PartyRoleKind.find_by(key: :self),
	                                                Parties::PartyRoleKind.find_by(key: :spouse),
	                                                Parties::PartyRoleKind.find_by(key: :domestic_partner),
	                                                Parties::PartyRoleKind.find_by(key: :child),
	                                                Parties::PartyRoleKind.find_by(key: :dependent),
	                                              ]
                                              )

      Parties::PartyRelationshipKind.create!(	key: :family_rollup, title: 'TPA Relationship',
                                              party_role_kinds: [
	                                                Parties::PartyRoleKind.find_by(key: :tpa),
	                                                Parties::PartyRoleKind.find_by(key: :employer),
	                                              ]
                                              )
    end

  end
end

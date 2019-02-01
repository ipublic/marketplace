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
	  validate :related_party_presence

	  delegate :key, 					to: :party_role_kind, allow_nil: true
	  delegate :title, 				to: :party_role_kind, allow_nil: true
	  delegate :description, 	to: :party_role_kind, allow_nil: true
	  delegate :party_relationship_kinds, 	to: :party_role_kind, allow_nil: true
	  delegate :eligibility_policy, 	to: :party_role_kind, allow_nil: true

	  def is_active?
	  	end_date.blank? || end_date >= Date.today
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

	  def related_party_presence
	  	if party_relationship_kinds.present?

	  		errors.add(:related_party, "party_role #{title} requires a related party instance") if related_party.blank?
	  		errors.add(:related_party, "party_role #{title} related party kinds #{party_relationship_kinds.inspect} don't match party_relationship definition") unless party_roles_match?
  		else
  			errors.add(:related_party, "unexpected related_party #{related_party.inspect} for party_role #{title}") if related_party.present?
	  	end
	  end

	  # Party roles must match valid role-to-role relationship definition
	  # Compare Roles for this and associated party
	  def party_roles_match?
	  	return false if related_party.blank?
    	party_relationship_kinds.sort == [party_role_kind.key, related_party.party_role_kind.key].sort
  	end



		def roles
			[
				:uits_primary_contact,
				:uits_secondary_contact,
				:uits_owner_officer,

			]

		end


		def dc_does_organization
			{
				party_roles: [
					{kind: :internal_organization},
					{kind: :parent_organization}
				]
			}
		end

		def dc_uits_dept
			{
				party_roles: [
					{kind: :internal_organization},
					{kind: :subsidiary_organization}
				]
			}
		end


		def relationship_kind
			{kind: :employment, 	from_party: :dan_person, from_role: :employee, 		to_party: :ideacrew_organization, to_role: :employer}
			{kind: :organization_contact, from_party: :dan_person, from_role: :hr_manager, 	to_party: :dc_uits_dept, to_role: :uits_agency}
			{kind: :organization_contact, from_party: :dan_person, from_role: :hr_manager, 	to_party: :dc_pflts_dept, to_role: :pflts_agency}
		end

		# Acting as
    def party_role_kind_roles
    	list = [:employee, :family_member, :contact]
      [
		    	Parties::PartyRole.new({role_kind: :employee, relationship_kind: :employment, related_party: :ideacrew_organization }),
		    	{role_kind: :employee, relationship_kind: :employment, related_party: :ideacrew_organization },
		    	{role_kind: :contact, relationship_kind: :organization_contact, related_party: :ideacrew_organization },
	    	]
    end

    def organization_party_roles
    	kinds = [:regulatory_agency, :household]
    	organization_unit_kinds = [:parent_organization, :subsidiary, :department, :division]
    	uits_kinds = [:site_owner, :successor] 
    	{
    		party_roles: [
    			{role_kind: :employer, relationship_kind: :employment, related_party: :dan_person },
    		]
    	}
	    { kind: :customer, related_party: :dchbx }
	    { kind: :lklj}
	  end


	end
end

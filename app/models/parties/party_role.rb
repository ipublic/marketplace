module Parties
	class PartyRole
	  include Mongoid::Document
	  include Mongoid::Timestamps

	  # embedded_in :party,
	  # 						class_name: "Parties:Party"

	  belongs_to :party,
	  						class_name: "Parties:Party"

	  # field :kind_id, type: BSON::ObjectId

	  # Date this party_role becomes effective
	  field :start_date, type: Date

	  # Date this party_role is no longer in effect
	  field :end_date, type: Date

	  delegate :title, 				to: :party_role_kind, allow_nil: true
	  delegate :description, 	to: :party_role_kind, allow_nil: true

	  embeds_one 	:party_role_kind,
	  						class_name: "Parties::PartyRoleKind",
	  						autobuild: true


	  def is_active?
	  	end_date.blank? || end_date >= Date.today
	  end

	  def kind=(new_kind)
      if new_kind.nil?
        write_attribute(:kind_id, nil)
      else
        raise ArgumentError.new("expected Parties::PartyRoleKind") unless new_kind.is_a? Parties::PartyRoleKind 
        write_attribute(:kind_id, new_kind._id)
      end
      @kind = new_kind
	  end

	  def kind
	    return nil if kind_id.blank?
	    return @kind if defined? @kind
	    @kind = Parties::PartyRoleKind(kind_id)
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

    def dan_person
      { 
	    	party_roles: [
		    	{role_kind: :person, relationship_kind: :employment, related_party: :ideacrew_organization },
		    	{role_kind: :employee, relationship_kind: :employment, related_party: :ideacrew_organization },
		    	{role_kind: :contact, relationship_kind: :organization_contact, related_party: :ideacrew_organization },
	    	]
	    }
    end

    def ideacrew_organization
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

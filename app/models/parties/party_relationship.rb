class Parties::PartyRelationship
  include Mongoid::Document
  include Mongoid::Timestamps

  # embedded_in :party_role,
  # 						class_name: "Parties::PartyRole"

  # field :related_party_id, type: BSON::ObjectId


  field :party_relationship_kind_id,  type: BSON::ObjectId

  # Begin date for this relationship
  field :start_date, type: Date 

  # End date for this relationship
  field :end_date, type: Date

  # embeds_one  :party_relationship_kind,
  #             class_name: "Parties::PartyRelationshipKind"

  delegate :key,                  to: :party_relationship_kind
  delegate :title,                to: :party_relationship_kind
  delegate :description,          to: :party_relationship_kind
  delegate :party_relationships,  to: :party_relationship_kind


  def related_party=(new_related_party)
      if new_related_party.nil?
        write_attribute(:related_party_id, nil)
      else
        raise ArgumentError.new("expected Parties::Party") unless new_related_party.is_a? Partys::BenefitApplication
        write_attribute(:related_party_id, new_related_party._id)
      end
      @related_party = new_related_party
  end

  def related_party
    return nil if related_party_id.blank?
    return @related_party if defined? @related_party
    @related_party = benefit_sponsorship.benefit_applications_by(related_party_id)
  end

  def party_relationship_kind=(new_party_relationship_kind)
      if new_party_relationship_kind.nil?
        write_attribute(:party_relationship_kind_id, nil)
      else
        raise ArgumentError.new("expected Parties:PartyRelationshipKind") unless new_party_relationship_kind.is_a? Parties:PartyRelationshipKind
        write_attribute(:party_relationship_kind_id, new_party_relationship_kind._id)
      end
      @party_relationship_kind = new_party_relationship_kind
  end

  def party_relationship_kind
    return nil if party_relationship_kind_id.blank?
    return @party_relationship_kind if defined? @party_relationship_kind
    @party_relationship_kind = Parties:PartyRelationshipKind.find(party_relationship_kind_id)
  end

  def kjldfjk
  	{
  		relationship: :employment,
  		arity: :group_to_group,
  		industries: [:health, :unemployment, :paid_family_leave]
  	}
  end


  def group_to_group_relationship_kinds

  end

  def individual_to_individual_relationship_kinds

  end


  def relationship_kinds
  	[
  			:organization_contact,
  			:employment,
  			:unemployment_insurance_claiment,

  			:patient_provider,
  			:practice_affiliation,
  			:provider_network,
  		]
  end

  def person_party_roles_kinds
  	[:person, :organization_contact, :insured_contract_holder, :insured_dependent, :individual_health_care_practitioner, ]
  end

  def person_party_relationship_kinds
  	[:household_member, :family_dependency, :patient_practitioner_relationship]
  end

 # 	def examples
 #  dan_thomas: {
	#   relation_kind: 			:employed_by,
	#   relationship_party: :ideacrew,
	#   start_on: 					:date_1,
	#   end_on: 						:nil,
	# }

 #  dan_thomas: {
	#   relation_kind: 			:cobra_by,
	#   relationship_party: :ideacrew,
	#   start_on: 					:date_1,
	#   end_on: 						:nil,
	# }

 #  dan_thomas: {
	#   relation_kind: 			:organization_contact,
	#   relationship_party: :ideacrew,
	#   start_on: 					:date_1,
	#   end_on: 						:date_2,
	# }

	# ideacrew: {
	# 	relationship_kind: 	:ui_tpa_representation,
	# 	relationship_party: :tpa_1,
	#   start_on: 					:date_1,
	#   end_on: 						:date_2,
	# }

	# tpa_agent1: {
	# 	relationship_kind: 	:ui_tpa_representative,
	# 	relationship_party: :tpa_1,
	#   start_on: 					:date_1,
	#   end_on: 						:date_2,
	# }


 #  def person
 #  	{
 #  		person_party: "john",
 #  			party_role_kinds: [:person, :patient, :insured_contract_holder],
 #  			party_relationships: [
 #  				{
	#   				relationship_kind: 	:patient_practitioner_relationship,
	#   				related_party: 			"dr jones",
	#   				party_role_kind: 		:patient,
	#   				related_role: 			:individual_health_care_practitioner,
	#   				start_date: 				"Wed, 03 Oct 2018",
	#   				end_date: 					"Thu, 04 Oct 2018",
	#   			},
 #  				{
	#   				relationship_kind: 	:household_member,
	#   				related_party: 			"smith",
	#   				party_role_kind: 		:person,
	#   				related_role: 			:household,
	#   				start_date: 				"Wed, 03 Oct 2018",
	#   				end_date: 					"Thu, 04 Oct 2018",
	#   			},
 #  				{
	#   				relationship_kind: 	:family_dependency,
	#   				related_party: 			"jane",
	#   				party_role_kind: 		:insured_contract_holder,
	#   				related_role: 			:insured_dependent,
	#   				start_date: 				"Wed, 03 Oct 2018",
	#   				end_date: 					"Thu, 04 Oct 2018",
	#   			},
 #  			]
 #  	}
	# end

 #  def transaction_detail
 #  	{ id: 123, payload: [
	#   		{ subject_role: :person, 	id: "john", related_role: :household, related_party: "smith", relationship_kind: :household_member  },
	#   		{ subject_role: :person, 	id: "jane", related_role: :household, related_party: "smith", relationship_kind: :household_member  },
	#   		{ subject_role: :insured_contract_holder, id: "john", related_role: :insured_dependent, id: "jane", relationship_kind: :family_dependency  },
	#   		{ subject_role: :patient, id: "john", related_role: :individual_health_care_practitioner, id: "dr jones", relationship_kind: :patient_practitioner_relationship  },
	#   	]
 #  	}
	# end


  # class PatientPractitionerRelationship
  # 	has_one  :patient
  # 	has_many :health_care_provider_organization

  # 	field :is_primary_care_provider, type: Boolean

  # end

  # class PracticeAffiliationRelationship
  # 	has_one  :individual_health_care_practitioner
  # 	has_many :health_care_provider_organizations

  # end

  # class ProviderNetworkRelationship
  # 	has_one :provider 
  # 	has_many :health_care_networks
  # end

end

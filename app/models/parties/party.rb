class Parties::Party
  include Mongoid::Document
  include Mongoid::Timestamps

	field 			:party_id, type: Integer

  embeds_many :party_roles, 
							class_name: "Parties::PartyRole"

  embeds_many :party_relationships,
  						class_name: "Parties::PartyRelationship"

  embeds_many :determinations,
  						class_name: "Determinations::Determination"

	has_many		:notices,
							class_name: "Notices::Notice"

	has_many 		:accounts,
							class_name: "Accounts::Account"

  scope :ui_group_sponsors,		->{ any_in(party_roles: [:unemployment_insurance_group_sponsor])}
	scope :ui_tpas, 						->{ any_in(party_roles: [:unemployment_insurance_tpa]) } 				# need to check end_date for active
	scope :ui_tpa_agents, 			->{ any_in(party_roles: [:unemployment_insurance_tpa_agent]) } 	# need to check end_date for active

  scope :pfl_group_sponsors,	->{ any_in(party_roles: [:paid_family_leave_group_sponsor])}
	scope :pfl_tpas, 						->{ any_in(party_roles: [:paid_family_leave_tpa]) } 				# need to check end_date for active
	scope :pfl_tpa_agents, 			->{ any_in(party_roles: [:paid_family_leave_tpa_agent]) } 	# need to check end_date for active

  scope :active_on,						->(compare_date){ where(:begin_on.lte => date, :end_on.gte => date) unless date.blank? }

  scope :clients_for_tpa,					->(third_party_administrator){}
  scope :employees_for_employer, 	->(employer){}


	index({ party_id: 1 })
  index({"party_role.kind" => 1})

  def has_role?(role_kind)
  	party_roles.include?(role_kind)
  end

  def has_relationship?(relationship_kind)
  	party_relationships.include?(relationship_kind)
  end

  def add_party_role(new_role, start_date=Date.today)

  	party_roles
  end

  def drop_party_role(dropped_role, end_date=Date.today)

  	party_roles
  end

  def add_party_relationship(new_relationship, related_party, start_date=Date.today)

  	party_relationships
  end

  def drop_party_relationship(dropped_relationship, related_party, end_date=Date.today)

  	party_relationships
  end

  # Universal Roles a Party can assume
  def self.all_party_roles
  	[]
  end

  IndividualParty.new({
  		current_first_name: "Dan",
  		current_last_name:  "Thomas",

  		party_roles: [
  				{role_kind: :employee, start_date: Date.new(2003,1,1) },
  			],
			party_relationships: [
					{relationship_kind: :organization_contact, related_party: :ideacrew, start_date: Date.new(2003,1,1), thru_date: Date.new(2016,1,1) },
					{relationship_kind: :employment, related_party: :ideacrew, start_date: Date.new(2003,1,1), thru_date: nil }
				]
			}

  	)



end

module Parties
	class Party
	  include Mongoid::Document
	  include Mongoid::Timestamps

		field	:party_id, 					type: Integer
	  field :registered_on, 		type: Date, default: ->{Date.today} #{ TimeKeeper.date_of_record }

	  field :profile_source, 		type: Symbol, default: :self_serve
	  field :contact_method, 		type: String, default: "Only Electronic communications"


	  has_many 		:party_role_kinds,
								class_name: "Parties::PartyRoleKind"

		has_many		:notices,
								class_name: "Notices::Notice"

		has_many 		:financial_accounts,
								class_name: "FinancialAccounts::FinancialAccount"

	  embeds_many :party_roles, 
								class_name: "Parties::PartyRole"

	  embeds_many :determinations,
	  						class_name: "Determinations::Determination"


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

	  def has_role_kind?(role_kind)
	  	party_roles.include?(role_kind)
	  end

	  def has_relationship?(relationship_kind)
	  	party_relationships.include?(relationship_kind)
	  end

	  def add_party_role(new_role)
	  	if new_role.eligibility_policy.present? && new_role.eligibility_policy.satisfied?
		  	party_roles << new_role unless party_roles_by_kind(new_role)
		  end

	  	party_roles
	  end

	  def drop_party_role(dropped_role)

	  	party_roles
	  end

	  def terminate_party_role(role_kind, end_date=Date.today)
	  end

	  def active_party_roles_by_kind(role_kind)
	  	party_roles_by_kind(role_kind).reduce([]) { |list, role| ist << role.kind if role.is_active? }
	  end

	  def party_roles_by_kind(role_kind)
	  	party_roles.reduce([]) { |list, role| list << role.kind if role == role_kind }
	  end

	  def add_party_relationship(new_relationship)
	  	party_relationships << new_relationship
	  end

	  def drop_party_relationship(dropped_relationship)

	  	party_relationships
	  end

	  # Universal Roles a Party can assume
	  def self.all_party_roles
	  	[]
	  end



	end
end

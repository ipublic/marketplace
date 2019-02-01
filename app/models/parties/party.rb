module Parties
	class Party
	  include Mongoid::Document
	  include Mongoid::Timestamps

		field	:party_id, 					type: Integer
	  field :registered_on, 		type: Date, default: ->{Date.today} #{ TimeKeeper.date_of_record }

	  field :profile_source, 		type: Symbol, default: :self_serve
	  field :contact_method, 		type: Symbol, default: :only_electronic_communications


	  # has_and_belongs_to_many :party_relationships, 
	  # 												class_name: 'Parties::PartyRelationship'

	  embeds_many		:party_roles, 
									class_name: "Parties::PartyRole"

	  embeds_many		:documents, as: :documentable,
	  							class_name: '::Document'

	  has_one			:party_ledger, 
								class_name: "Parties::PartyRole"

	  has_many		:party_ledger_account_balances, 
								class_name: "FinancialAccounts::PartyLedgerAccountBalance"

	  has_many		:determinations,
	  						class_name: "Determinations::Determination"

		has_many		:cases,
								class_name: "Cases::Case"

		has_many		:notices,
								class_name: "Notices::Notice"

		scope :associated_parties,	->{ where("party_roles.related_party_id": _id) }

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
	  index({"party_roles.party_role_kind_id": 1})
	  index({"party_roles.related_party_id": 1}, {sparse: true})

	  def active_party_roles_by_key(role_key)
	  	party_roles_by_key(role_key).reduce([]) { |active_list, role| active_list << role if role.is_active? }
	  end

	  # Find roles that match passed key
	  def party_roles_by_key(role_key)
	  	party_roles.select { |party_role| party_role if party_role.key == role_key }
	  end

	  def active_party_roles_for(compare_role)
	  	party_roles_for(compare_role).reduce([]) { |list, role| list << role if role.is_active? }
	  end

	  # Find both declaritive roles and roles with specific relationships
	  def party_roles_for(compare_role)
	  	party_roles.select { |party_role| party_role if party_role == compare_role }
	  end

	  def has_relationship?(relationship_kind)
	  	party_relationships.include?(relationship_kind)
	  end

	  def add_party_role(new_role)
	  	# if new_role.eligibility_policy.present? && new_role.eligibility_policy.satisfied?
		  # end

	  	party_roles << new_role # unless party_roles_by_kind(new_role)

	  	party_roles
	  end

	  def end_party_role(ended_role)

	  	party_roles
	  end

	  def terminate_party_role(role_kind, end_date=Date.today)
	  end

	  def active_party_roles_by_kind(role_kind)
	  	party_roles_by_kind(role_kind).reduce([]) { |list, role| list << role.kind if role.is_active? }
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

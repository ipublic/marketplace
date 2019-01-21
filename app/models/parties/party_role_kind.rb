class Parties::PartyRoleKind
  include Mongoid::Document

  field :kind,									type: Symbol
  field :title, 								type: String
  field :description, 					type: String

  field :start_on, 							type: Date
  field :end_on, 								type: Date
  field :is_published, 					type: Boolean

  embeds_one :eligibility_policy

  index({ kind: 1, start_on: 1, end_on: 1 })

  def publish
  	write_attribute(:is_published, true)
  end

  def unpublish
  	write_attribute(:is_published, false)
  end

  def is_draft?
  	!is_published?
  end

  def may_publish?
  	# is_draft? && Date.today <= 
  end

end

				:unemployment_insurance_individual_sponsor,
				:unemployment_insurance_claiment,
				:paid_family_leave_claiment,
				:employee,
				:health_insurance_contract_holder,


Parties::PartyRoleKind.new({kind: :unemployment_insurance_group_sponsor, title: "", description: "An employer who manages unemployment insurance tax for its employees", is_published: true})
Parties::PartyRoleKind.new({kind: :unemployment_insurance_claiment, title: "", description: "", is_published: true})
Parties::PartyRoleKind.new({kind: :paid_family_leave_group_sponsor, title: "", description: "", is_published: true})
Parties::PartyRoleKind.new({kind: :employer, title: "", description: "", is_published: true})
Parties::PartyRoleKind.new({kind: :health_insurance_group_sponsor, title: "", description: "An employer or organization who sponsors health insurance benefits for its members", is_published: true})
Parties::PartyRoleKind.new({kind: :health_insurance_contract_holder, title: "", description: "", is_published: true})

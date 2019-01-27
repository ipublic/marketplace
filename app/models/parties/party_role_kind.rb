# Actor roles or categories that a Party entity plays in the context of the enterprise.  
module Parties
	class PartyRoleKind
	  include Mongoid::Document
	  include Mongoid::Timestamps

	  belongs_to	:party,
	  						class_name: "Parties::Party"

	  field :key,										type: Symbol
	  field :title, 								type: String
	  field :description, 					type: String

	  field :has_related_parties,			type: Boolean, default: false
	  field :related_party_kinds,			type: Array, default: []

	  # Used for enabling/disabling role kinds over time
	  field :is_published, 					type: Boolean, default: true
	  field :start_date, 						type: Date
	  field :end_date, 							type: Date

	  # Associate a business rule for validating a role instance
	  embeds_one :eligibility_policy

	  index({ key: 1, is_published: 1, start_date: 1, end_date: 1 })

	  alias_method :is_published?, 				:is_published
	  alias_method :has_related_parties?, :has_related_parties

	  def title
	  	title.present? ? title : key.to_s.gsub('_', ' ')
	  end

	  def publish
	  	write_attribute(:is_published, true)
	  end

	  def unpublish
	  	write_attribute(:is_published, false)
	  end

	  def is_draft?
	  	!is_published?
	  end

	end

end



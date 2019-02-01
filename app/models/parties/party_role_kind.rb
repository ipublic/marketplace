# Actor roles or categories that a Party entity plays in the context of the enterprise.  
module Parties
	class PartyRoleKind
	  include Mongoid::Document
	  include Mongoid::Timestamps

	  field :key,										type: Symbol
	  field :title, 								type: String
	  field :description, 					type: String

	  field :has_related_parties,		type: Boolean, 	default: false
	  # field :related_party_kinds,		type: Array, 		default: []

	  # Used for enabling/disabling role kinds over time
	  field :is_published, 					type: Boolean, 	default: true
	  field :start_date, 						type: Date, 		default: ->{ TimeKeeper.date_of_record }
	  field :end_date, 							type: Date

	  has_and_belongs_to_many	:party_relationship_kinds,
	  												class_name: "Parties::PartyRelationshipKind"

		# embeds_one	:related_party,
		# 						class_name: "Parties::Party"

	  # Associate a business rule for validating a role instance
	  has_one 	:eligibility_policy

	  # validates_presence_of :key, :title

	  index({ key: 1, is_published: 1, start_date: 1, end_date: 1 })

	  # before_validation :set_key

	  alias_method :is_published?, 				:is_published
	  # alias_method :has_related_parties?, :has_related_parties

	  def key=(new_key)
	  	write_attribute(:key, new_key.to_s.underscore.to_sym)
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

	  private

	  def set_key
	  	key = title if key.blank?
	  end
	end

end



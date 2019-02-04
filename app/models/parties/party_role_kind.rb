# Actor roles or categories that a Party entity plays in the context of the enterprise.  
module Parties
	class PartyRoleKind
	  include Mongoid::Document
	  include Mongoid::Timestamps

	  field :key,										type: Symbol
	  field :title, 								type: String
	  field :description, 					type: String

	  # Used for enabling/disabling role kinds over time
	  field :is_published, 					type: Boolean, 	default: true
	  field :start_date, 						type: Date, 		default: ->{ TimeKeeper.date_of_record }
	  field :end_date, 							type: Date

	  has_and_belongs_to_many	:party_relationship_kinds,
	  												class_name: "Parties::PartyRelationshipKind"

    has_many 			:party_roles,
    							class_name: 'Parties::PartyRole'

	  # Associate a business rule for validating a role instance
		belongs_to		:eligibility_policy,
									class_name: 'EligibilityPolicies::EligibilityPolicy',
									optional: true


	  before_validation :assign_key_and_title

	  validates_presence_of :key, :title, :start_date, :is_published
    validates_uniqueness_of :key

	  index({ key: 1}, { unique: true })
	  index({ is_published: 1, start_date: 1, end_date: 1 })

	  # before_validation :set_key

	  alias_method :is_published?, 				:is_published

    def has_party_relationship_kinds?
    	party_relationship_kinds.size > 0
    end

	  def key=(new_key)
	  	write_attribute(:key, text_to_symbol(new_key))
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

	  def assign_key_and_title
	  	write_attribute(:key, text_to_symbol(title)) if key.blank? && title.present?
	  	write_attribute(:title, symbol_to_text(key)) if title.blank? && key.present?
	  end

		def text_to_symbol(text)
			text.to_s.parameterize.underscore.to_sym
		end

  	def symbol_to_text(symbol)
  		symbol.to_s.titleize
  	end

    def self.is_valid_key?(key)
      all.pluck(:key).include?(key)
    end
	end
end

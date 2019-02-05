module Parties
	class PersonParty < Party

	  GENDER_KINDS = %W(male female)

	  field :business_title,			type: String

	  field :current_first_name, 	type: String
	  field :current_middle_name,	type: String
	  field :current_last_name, 	type: String
	  field :current_name_pfx, 		type: String
	  field :current_name_sfx, 		type: String

	  field :ssn, 								type: String
	  field :gender, 							type: String
  	field :dob, 								type: Date

  	# delegate :party_relationships, to: :party_roles

  	embeds_many	:person_names,
  							class_name: "Parties::PersonName"

	  validates_presence_of	:current_first_name, :current_last_name

	  #validates :ssn, uniqueness: true, allow_blank: true

	  validates :gender,
	    allow_blank: true,
	    inclusion: { in: GENDER_KINDS, message: "%{value} is not a valid gender" }

	  index({current_last_name: 1, current_first_name: 1})
	  index({current_first_name: 1, current_last_name: 1})
	  index({ssn: 1}, {sparse: true})
	  index({dob: 1}, {sparse: true})

	  scope :employed_by, 	-> (party){} # party_relationship of employment, with 
	  scope :contact_for, 	-> (party){}

    def hide_ssn 
      if self.ssn 
      self.ssn.split('')[5..8].unshift("x","x-","x","x","x-").join('')
      else 
        ""
      end

    end
	end
end

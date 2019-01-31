module Cases
	class Case
	  include Mongoid::Document

    belongs_to	:party,
      			class_name: 'Parties;:Party'

	end
end

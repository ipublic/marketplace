module Determinations
	class Determination
	  include Mongoid::Document

	  belongs_to :effective_period

	  field :determined_at,	type: Time

	  has_many 		:timespans, 
	  						class_name: 'TimeSpans:Timespan'
	end
end

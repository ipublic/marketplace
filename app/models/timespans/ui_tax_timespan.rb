module Timespans
	class UiTaxTimespan < Timespan

	  field :title,			type: String
	  field :start_on, 	type: Date
	  field :end_on,		type: Date


	  private 

	  def compose_title
	  	# Example: '2019 Q1'
	  end
	end
end

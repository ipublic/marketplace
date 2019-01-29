module Timespans
	class QuarterYearTimespan < Timespan

		attr_readonly :year, :quarter, :begin_on, :end_on

	  field :year, 		type: Integer
	  field :quarter,	type: Integer

	  belongs_to	:calendar_year_timespan,
	  						class_name: 'Timespans::CalendarYearTimespan'

	  validates_presence_of :year

	  validates :quarter, 
	  					presence: true,
	            numericality: { only_integer: true,
	            								greater_than_or_equal_to: 1, less_than_or_equal_to: 4
	            							}

	  # Mongoid stores inherited classes as STI.  Year index is created in calendar_year_timespan
    index({quarter: 1 })

    scope :quarter_of_year, ->(year, quarter){}

		def beginning_of_quarter(new_year, new_quarter)
		  Date.new(new_year, new_quarter * 3 - 2) if (1..4).cover? new_quarter
		end

		def end_of_quarter(new_year, new_quarter)
		  Date.new(new_year, new_quarter * 3, -1) if (1..4).cover? new_quarter
		end

		private

		def initialize_timespan

			if year.present? && quarter.present?
				write_attribute(:begin_on, beginning_of_quarter(year, quarter)) if begin_on.blank?
				write_attribute(:end_on, end_of_quarter(year, quarter)) if end_on.blank?
				write_attribute(:title, "#{year} Q#{quarter}") if title.blank?
			end
		end

	end
end

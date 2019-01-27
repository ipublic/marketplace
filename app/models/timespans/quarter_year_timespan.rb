module Timespans
	class QuarterYearTimespan < Timespan
  	include Mongoid::Document
	  include Mongoid::Timestamps

	  # embedded_in	:calendar_year_timespan,
	  # 						class_name: 'Timespans::CalendarYearTimespan'

	  field :year, 		type: Integer
	  field :quarter,	type: Integer

	  validates :year, 
	  					presence: true,
	            numericality: { only_integer: true,
	            								greater_than_or_equal_to: YEAR_MINIMUM, less_than_or_equal_to: YEAR_MAXIMUM
	            							}

	  validates :quarter, 
	  					presence: true,
	            numericality: { only_integer: true,
	            								greater_than_or_equal_to: 1, less_than_or_equal_to: 4
	            							}

	  # validates :quarter, presence: true,
	  #           numericality: { only_integer: true, less_than_or_equal_to: 4 }

    after_validation :initialize_attributes

		def beginning_of_quarter(new_year, new_quarter)
		  Date.new(new_year, new_quarter * 3 - 2) if (1..4).cover? new_quarter
		end

		def end_of_quarter(new_year, new_quarter)
		  Date.new(new_year, new_quarter * 3, -1) if (1..4).cover? new_quarter
		end

		private

		def initialize_attributes
			return unless quarter.present?

			if year.present? && begin_on.blank?
				write_attribute(:begin_on, beginning_of_quarter(year, quarter))
			end

			if year.present? && end_on.blank?
				write_attribute(:end_on, end_of_quarter(year, quarter))
			end

			write_attribute(:title, "#{year} Q#{quarter}") if title.blank?
		end

	end
end

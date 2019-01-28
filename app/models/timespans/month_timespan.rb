module Timespans
	class MonthTimespan < Timespan

		attr_readonly :year, :month, :begin_on, :end_on

    field :month, type: Integer
    field :year,  type: Integer

	  belongs_to	:calendar_year_timespan,
	  						class_name: 'Timespans::CalendarYearTimespan'

    validates_presence_of :year

	  validates :month, 
	  					presence: true,
	            numericality: { only_integer: true,
	            								greater_than_or_equal_to: 1, less_than_or_equal_to: 12
	            							}

    index({ year: 1, month: 1 }, {unique: true} )

    scope :month_of_year, ->(year, month){}

		def beginning_of_month(new_year, new_month)
		  Date.new(new_year, new_month)
		end

		def end_of_month(new_year, new_month)
		  Date.new(new_year, new_month).end_of_month
		end

    private

    def initialize_timespan

			if year.present? && month.present?
				write_attribute(:begin_on, beginning_of_month(year, month)) if begin_on.blank?
				write_attribute(:end_on, beginning_of_month(year, month)) if end_on.blank?
				write_attribute(:title, "#{year} #{Date::ABBR_MONTHNAMES[month]}") if title.blank?
			end
    end

  end
end

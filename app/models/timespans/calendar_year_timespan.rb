module Timespans
	class CalendarYearTimespan < Timespan

    field :year,  type: Integer

    has_many	:quarter_year_timespans,
    						class_name: 'Timespans::QuarterYearTimespan'

    has_many	:month_timespans,
    						class_name: 'Timespans::MonthTimespan'

    index({ year: 1}, {unique: true})

    index({ 'month_timespans.year': 1,
    				'month_timespans.month': 1 },
    				{unique: true})

	  validates :year, 
	  					presence: true,
	            numericality: { only_integer: true,
	            								greater_than_or_equal_to: YEAR_MINIMUM, 
	            								less_than_or_equal_to: YEAR_MAXIMUM
	            							}

    validates_presence_of :quarter_year_timespans, :month_timespans


    private

		def initialize_timespan
			if year.present?
				initialize_calendar_year_timespan
				initialize_quarter_year_timespans
				initialize_month_timespans
				initialize_title
			end
		end  

		def initialize_calendar_year_timespan
			write_attribute(:begin_on, Date.new(year))
			write_attribute(:end_on, Date.new(year).end_of_year)
		end

    def initialize_quarter_year_timespans
    	(1..4).map { |new_quarter| quarter_year_timespans.build(year: year, quarter: new_quarter) }
    end

    def initialize_month_timespans
    	(1..12).map { |new_month| month_timespans.build(year: year, month: new_month) }
    end

    def initialize_title
			write_attribute(:title, "#{year}") if title.blank?
		end
	end

	class SeedCalendarYear
		
		# (Timespans::YEAR_MINIMUM..Timespans::YEAR_MAXIMUM).each do |calendar_year|
		# end
		
	end
end

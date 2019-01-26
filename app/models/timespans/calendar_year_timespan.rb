module Timespans

	class CalendarYearTimespan
  	include Mongoid::Document
	  include Mongoid::Timestamps


    field :year,  type: Integer

    embeds_many	:quarter_year_timespans,
    						class_name: 'Timespans::QuarterYearTimespan'

    embeds_many	:month_timespans,
    						class_name: 'Timespans::MonthTimespan'

    index({ year: 1}, {unique: true})
    index({ 'quarter_year_timepans.year': 1,
    				'quarter_year_timepans.quarter': 1 }, 
    				{unique: true})

    index({ 'month_timespans.year': 1,
    				'month_timespans.month': 1 },
    				{unique: true})

    validates_presence_of :quarter_year_timepans, :month_timespans

    after_initialize :pre_allocate_timespan


    def initialize_quarter_year_timespans
    	1..4.map { |new_quarter| quarter_year_timespan.build(year: year, quarter: new_quarter) }
    end

    def initialize_month_timespans
    	1..4.map { |new_quarter| quarter_year_timespan.build(year: year, quarter: new_quarter) }
    end

    def increment(new_date)
      day_of_month = new_date.day

      # Use the Mongoid increment (inc) function
      inc(("d" + day_of_month.to_s).to_sym => 1)
      self
    end

    private

		def pre_allocate_timespan
			initialize_quarter_year_timespans unless quarter_year_timepans.present?
		end  

	end

	class SeedCalendarYear
		
		# (Timespans::YEAR_MINIMUM..Timespans::YEAR_MAXIMUM).each do |calendar_year|
		# end
		
	end
end

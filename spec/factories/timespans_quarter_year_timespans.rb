FactoryBot.define do
  factory :timespans_quarter_year_timespan, class: 'Timespans::QuarterYearTimespan' do

    year			{ Date.today.year }
		quarter 	{ 2 }  
		
  end
end

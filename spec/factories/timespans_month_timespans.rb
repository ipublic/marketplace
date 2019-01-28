FactoryBot.define do
  factory :timespans_month_timespan, class: 'Timespans::MonthTimespan' do

    year			{ Date.today.year }
		month 		{ 6 }  

  end
end

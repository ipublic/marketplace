FactoryBot.define do
  factory :timespans_calendar_year_timespan, class: 'Timespans::CalendarYearTimespan' do

    year		{ Date.today.year }

  end
end

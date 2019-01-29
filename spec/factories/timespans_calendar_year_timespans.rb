FactoryBot.define do
  factory :timespans_calendar_year_timespan, class: 'Timespans::CalendarYearTimespan' do

    year		{ TimeKeeper.date_of_record.year }

  end
end

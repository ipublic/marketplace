puts "*"*80
puts "Purging Database and Removing Indexes"
system "rake db:mongoid:purge"
system "rake db:mongoid:remove_indexes"
puts "*"*80

puts "*"*80
puts "Start of seed data"
puts "*"*80

puts "*"*80
puts "Loading Timespans"
# (Timespans::YEAR_MINIMUM..Timespans::YEAR_MAXIMUM).map { |year| Timespans::CalendarYearTimespan.create(year) }
(1980..2030).map { |year| Timespans::CalendarYearTimespan.create(year: year) }
puts "*"*80

puts "*"*80

puts "*"*80
puts "Creating Organization Parties and Wage Reports"

legal_first_names = ["Tom's","John's", "Bob's", "Jan's", "Kathy's"]
legal_last_names = ["CookHouse","Car Rental", "Burgers", "Autobody","Jewelry"]
person_first_names =  ["Joe", "Jim", "Sam", "Alex","Sara","Matt", "Trey", "Dan", "Kristen"]
person_last_names = ["Johnson", "Farrell", "Smith", "Jenkins","Golen","Thompson", "Belvedere", "Sims", "Brown"]

1..30.times do 
 person  = Parties::PersonParty.create(current_first_name:"#{person_first_names.sample}",current_last_name:"#{person_last_names.sample}")
 party = Parties::OrganizationParty.create(fein:"#{rand(000000000...999999999)}", legal_name:"#{legal_first_names.sample + legal_last_names.sample}", entity_kind:"#{Parties::OrganizationParty::ENTITY_KINDS.sample}", is_foreign_entity:false)
 1..10.times do  
  wage  = Wages::Wage.new(person_party_id:person.id, state_qtr_total_gross_wages: "#{rand(100...1000)}",state_qtr_ui_total_wages:"#{rand(100...1000)}",state_qtr_ui_excess_wages:"#{rand(100...1000)}",state_qtr_ui_taxable_wages:"#{rand(100...1000)}")
  entry = Wages::WageEntry.new(wage: wage)
  span = Timespans::Timespan.all.sample
  Wages::WageReport.create!(organization_party:party, wage_entries:[entry], submission_kind: :original, timespans:[span] , filing_method_kind: :upload)
 end
end

puts "*"*80

puts "Creating Indexes"
system "rake db:mongoid:create_indexes"
puts "::: complete :::"

puts "End of Seed Data"



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
legal_last_names = ["Cook House","Car Rental", "Burgers", "Autobody","Jewelry"]
person_first_names =  ["Joe", "Jim", "Sam", "Alex","Sara","Matt", "Trey", "Dan", "Kristen"]
person_last_names = ["Johnson", "Farrell", "Smith", "Jenkins","Golen","Thompson", "Belvedere", "Sims", "Brown"]

1..30.times do 
  person  = Parties::PersonParty.create!(current_first_name:"#{person_first_names.sample}",current_last_name:"#{person_last_names.sample}")
  party = Parties::OrganizationParty.create!(fein:"#{rand(000000000...999999999)}", legal_name:"#{legal_first_names.sample + legal_last_names.sample}", is_foreign_entity:false)
  1..10.times do  
    entries = []
    span =  Timespans::Timespan.all.where('quarter' =>{'$in' => [1,2,3,4]}).sample
    1..10.times do 
      entry = Wages::WageEntry.new(submission_kind: :original, submitted_at: Time.now) 
      wage  = Wages::Wage.new(person_party_id:person.id,
                              state_total_gross_wages: "#{rand(100...1000)}",
                              timespan_id:span.id,
                              state_taxable_wages:"#{rand(100...1000)}",
                              wage_entry: entry,
                              state_total_wages:"#{rand(1000...10000)}",
                              state_excess_wages:"#{rand(100...1000)}" )
      entries  << entry
    end
      1..3.times do 
       report =  Wages::WageReport.create!(organization_party:party,
                                  timespan: span,
                                  submission_kind:  "#{Wages::WageReport::SUBMISSION_KINDS.sample}",
                                  timespans:[span],
                                  wage_entries:entries,
                                  filing_method_kind: "#{Wages::WageReport::FILING_METHOD_KINDS.sample}",
                                  status: "#{Wages::WageReport::STATUS_KINDS.sample}",
                                  state_total_gross_wages:"#{rand(10000...100000)}",
                                  state_ui_taxable_wages:"#{rand(100...1000)}",
                                  ui_total_due:"#{rand(500...1000)}",
                                  submitted_at: Time.now,
                                  state_ui_total_wages:"#{rand(1000...10000)}",
                                  state_ui_excess_wages:"#{rand(100...1000)}"  )
      report.wage_entries.each do |entry|
        entry.save!
        # require'pry'; binding.pry
      end
      report.save!
    end
  end
end

puts "*"*80

puts "Creating Indexes"
# system "rake db:mongoid:create_indexes"
puts "::: complete :::"

puts "End of Seed Data"



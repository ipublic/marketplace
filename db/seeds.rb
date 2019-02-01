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
puts "Creating PartyRoleKinds"
Parties::PartyRoleKind.create!(key: :site_owner, title: 'Site Owner')

Parties::PartyRoleKind.create!(key: :employee, title: 'Employee')
Parties::PartyRoleKind.create!(key: :employer, title: 'Employer')
Parties::PartyRoleKind.create!(key: :owner_or_officer, title: 'Owner/Officer')
Parties::PartyRoleKind.create!(key: :employer, title: 'Contractor')

Parties::PartyRoleKind.create!(key: :self, title: 'Self')
Parties::PartyRoleKind.create!(key: :spouse, title: 'Spouse')
Parties::PartyRoleKind.create!(key: :domestic_partner, title: 'Domestic Partner')
Parties::PartyRoleKind.create!(key: :child, title: 'Child')
Parties::PartyRoleKind.create!(key: :dependent, title: 'Dependent')

Parties::PartyRoleKind.create!(key: :primary_contact, title: 'Primary Contact')
Parties::PartyRoleKind.create!(key: :secondary_contact, title: 'Secondary Contact')

Parties::PartyRoleKind.create!(key: :parent_organization, title: 'Parent Organization')
Parties::PartyRoleKind.create!(key: :subsiary, title: 'Subsiary')
Parties::PartyRoleKind.create!(key: :department, title: 'Department')
Parties::PartyRoleKind.create!(key: :division, title: 'Division')
Parties::PartyRoleKind.create!(key: :internal_organization, title: 'Internal Organization')
Parties::PartyRoleKind.create!(key: :other_organization_unit, title: 'Other Organization Unit')

# Corporate Entity Kinds
Parties::PartyRoleKind.create!(key: :s_corporation, title: 'S Corporation')
Parties::PartyRoleKind.create!(key: :c_corporation, title: 'C Corporation')
Parties::PartyRoleKind.create!(key: :limited_liability_corporation, title: 'Limited Liability Corporation')
Parties::PartyRoleKind.create!(key: :limited_liability_partnership, title: 'Limited Liability Partnership')
Parties::PartyRoleKind.create!(key: :non_profit_501c3, title: 'Non Profit 501c(3) Corporation')
Parties::PartyRoleKind.create!(key: :other_non_profit, title: 'Other Non Profit')
Parties::PartyRoleKind.create!(key: :household_employer, title: 'Household Employer')

puts "Creating PartyRelationshipKinds"
Parties::PartyRelationshipKind.create!(	key: :employment, title: 'Employment',
                                        party_role_kinds: [
                                            Parties::PartyRoleKind.find_by!(key: :employee),
                                            Parties::PartyRoleKind.find_by!(key: :employer),
                                            Parties::PartyRoleKind.find_by!(key: :owner_or_officer),
                                          ]
                                        )

Parties::PartyRelationshipKind.create!(	key: :organization_rollup, title: 'Organization Contact',
                                        party_role_kinds: [
                                            Parties::PartyRoleKind.find_by!(key: :primary_contact),
                                            Parties::PartyRoleKind.find_by!(key: :secondary_contact),
                                          ]
                                        )

Parties::PartyRelationshipKind.create!(	key: :organization_entity, title: 'Organization Entity',
                                        party_role_kinds: [
                                            Parties::PartyRoleKind.find_by!(key: :parent_organization),
                                            Parties::PartyRoleKind.find_by!(key: :subsiary),
                                            Parties::PartyRoleKind.find_by!(key: :department),
                                            Parties::PartyRoleKind.find_by!(key: :division),
                                            Parties::PartyRoleKind.find_by!(key: :other_organization_unit),
                                          ]
                                        )


Parties::PartyRelationshipKind.create!(	key: :organization_rollup, title: 'Organization Rollup',
                                        party_role_kinds: [
                                            Parties::PartyRoleKind.find_by!(key: :parent_organization),
                                            Parties::PartyRoleKind.find_by!(key: :subsiary),
                                            Parties::PartyRoleKind.find_by!(key: :department),
                                            Parties::PartyRoleKind.find_by!(key: :division),
                                            Parties::PartyRoleKind.find_by!(key: :other_organization_unit),
                                          ]
                                        )

Parties::PartyRelationshipKind.create!(	key: :family_rollup, title: 'Family Rollup',
                                        party_role_kinds: [
                                            Parties::PartyRoleKind.find_by!(key: :self),
                                            Parties::PartyRoleKind.find_by!(key: :spouse),
                                            Parties::PartyRoleKind.find_by!(key: :domestic_partner),
                                            Parties::PartyRoleKind.find_by!(key: :child),
                                            Parties::PartyRoleKind.find_by!(key: :dependent),
                                          ]
                                        )

puts "Creating Organization Parties and Wage Reports"

legal_first_names = ["Tom's","John's", "Bob's", "Jan's", "Kathy's"]
legal_last_names = ["Cook House","Car Rental", "Burgers", "Autobody","Jewelry"]
person_first_names =  ["Joe", "Jim", "Sam", "Alex","Sara","Matt", "Trey", "Dan", "Kristen", "Jack","Cindy","Linda", "Elliot","Hannah","Kara", "Alexis", "Gabe"]
person_last_names = ["Johnson", "Farrell", "Smith", "Jenkins","Golen","Thompson", "Belvedere", "Sims", "Brown", "Harris", "Hessen", "Golden", "Waithe"]
1..30.times do
   Parties::PersonParty.create!(current_first_name:"#{person_first_names.sample}",current_last_name:"#{person_last_names.sample}")
end
1..30.times do
  party = Parties::OrganizationParty.create!(fein:"#{rand(111111111...999999999)}",
    legal_name:"#{legal_first_names.sample + " " + legal_last_names.sample}",
    is_foreign_entity: false)
  (1..10).each do  |i|
    entries = []
    span =  Timespans::Timespan.all.where('quarter' =>{'$in' => [1,2,3,4]})[i]

      1..10.times do
        person = Parties::PersonParty.all.sample
        entry = Wages::WageEntry.new(submission_kind: :original, submitted_at: Time.now)
        wage  = Wages::Wage.new(person_party_id: person.id,
                                state_total_gross_wages: "#{rand(100...1000)}",
                                timespan_id:span.id,
                                state_taxable_wages:"#{rand(100...1000)}",
                                state_total_wages:"#{rand(1000...10000)}",
                                state_excess_wages:"#{rand(100...1000)}",
                                wage_entry: entry )
        entries << entry
      end
       report =  Wages::WageReport.create!(organization_party: party,
                                  timespan: span,
                                  submission_kind:  "#{Wages::WageReport::SUBMISSION_KINDS.sample}",
                                  wage_entries: entries,
                                  filing_method_kind: "#{Wages::WageReport::FILING_METHOD_KINDS.sample}",
                                  status: :submitted,
                                  state_total_gross_wages:"#{rand(10000...100000)}",
                                  state_ui_taxable_wages:"#{rand(100...1000)}",
                                  ui_total_due:"#{rand(500...1000)}",
                                  submitted_at: Time.now,
                                  state_ui_total_wages:"#{rand(1000...10000)}",
                                  state_ui_excess_wages:"#{rand(100...1000)}",
                                  ui_paid_amount:"#{rand(100...1000)}",
                                  ui_tax_amount:"#{rand(100...400)}",
                                  ui_amount_due:"#{rand(100...400)}",
                                  total_employees: entries.size )
      report.wage_entries.each do |entry|
        entry.wage.save!
        entry.save!
      end
      report.save!
    end
  end
puts "*"*80

puts "Creating Indexes"
# system "rake db:mongoid:create_indexes"
puts "::: complete :::"

puts "End of Seed Data"



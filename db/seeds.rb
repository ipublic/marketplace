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

# Load Cupcake seed files
require File.join(File.dirname(__FILE__),'seedfiles', 'bakery_cupcake_seed')

# Load seedfiles folder files
require File.join(File.dirname(__FILE__),'seedfiles', 'party_roles_and_relationships_seed')

puts "Creating Organization Parties and Wage Reports"

# Favor more common entity types in the random selection
ENTITY_KINDS = [:s_corporation, :c_corporation, :s_corporation, :c_corporation, :s_corporation, :c_corporation, :limited_liability_corporation, :limited_liability_partnership, :non_profit_501c3, :other_non_profit, :household_employer]

legal_first_names = ["Bold Ideas", "Adaptas", "Integra Design", "Magna Solutions", "Omni Tech", "Affinity Investments", "Millenia Life", "Acme Widgets","Opal Banking", "Toro Capital", "IdeaCrew"]
person_first_names =  ["Jane", "Nora", "Samuel","Matthew", "Caroline", "John", "Sara","Mason","Kristen", "David", "William", "Kevin", "Jessica","Mary","David", "John"]
person_last_names = ["Carter", "Farrell", "Jackson", "Adams","Klein","Lopez", "Price", "Peterson", "Derby", "Harris", "Hessen", "Golden", "Waithe","Murray","Aykroyd","Chase", "Curtin", "Williams"]
1..30.times do
   Parties::PersonParty.create!(current_first_name:"#{person_first_names.sample}",current_last_name:"#{person_last_names.sample}", ssn: "#{rand(111111111...999999999)}")
end

legal_first_names.each do  |name|
  org = Parties::OrganizationParty.new(
    entity_id: "#{rand(10000...999999)}",
    fein: "#{rand(111111111...999999999)}",
    entity_kind: ENTITY_KINDS.sample,
    legal_name: name,
    is_foreign_entity: false)

  
  date_of_first_wages = Time.at(rand(Time.new(2015,1,1).to_i..Time.now.to_i)).to_date

  contact = Parties::PersonParty.new(current_first_name: "#{person_first_names.sample}", current_last_name: "#{person_last_names.sample}")
  role = Roles::RoleFactory.new(org, org.entity_kind).party_role if Parties::PartyRoleKind.is_valid_key?(org.entity_kind)

  party_relationship = Roles::RelationshipRoleFactory.new(contact, :contact, :organization_ui_primary_contact, org).party

  ui_financial_account  = FinancialAccounts::FinancialAccountFactory.call(org, account_kind: :ui_financial_account, initial_liability_date: date_of_first_wages)
  
  party_relationship.save!
  contact.save!
  ui_financial_account.save!
  org.party_ledger.save!
  org.save!
end

parties = Parties::OrganizationParty.all

parties.each do |party|
  (0..10).each do  |i|
    entries = []
    spans = [] 
    3.times do
      spans << Timespans::Timespan.current_quarters
    end
    spans = spans.flatten

      1..10.times do
        person = Parties::PersonParty.all.sample
        gross_wages= rand(1000...30000)

        entry = Wages::WageEntry.new(submission_kind: :original, submitted_at: Time.now)
        wage  = Wages::Wage.new(person_party_id: person.id,
                                state_total_gross_wages: gross_wages,
                                timespan_id: spans[i].id,
                                state_taxable_wages: Wages::Wage.new.sum_taxable_wages(gross_wages),
                                state_total_wages:gross_wages,
                                state_excess_wages: Wages::Wage.new.sum_excess_wages(gross_wages),
                                wage_entry: entry )

        entries << entry
      end
       report =  Wages::WageReport.create!(organization_party: party,
                                  timespan: spans[i],
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

puts "Creating sample TPAs"
first_names = ['Dave', 'Sue', 'Mike', 'Ann', 'Jim', 'Carol']
last_names = ['Adams', 'Brown', 'Collins', 'Douglas', 'Harris', 'Ingrid']

(0..5).each do |i|
  person = Parties::PersonParty.create!(current_first_name:"#{first_names[i]}",current_last_name:"#{last_names[i]}", ssn: "#{rand(111111111...999999999)}")
  tpa_party_role_kind = Parties::PartyRoleKind.where(key: :tpa).first
  tpa_party_relationship_kind = Parties::PartyRelationshipKind.where(key: :ui_tpa_relationship).first
  person.party_roles.create!(party_role_kind: tpa_party_role_kind, party_relationship_id: tpa_party_relationship_kind.id)
end

puts "Creating Roles and Keys"
roles = ['UITS Administrator', 'UITS Call Center', 'Employer', 'Third Party Administrator', 'Call Center']
keys = ['Configure Settings', 'Create/Manage Employers', 'Create/Manage TPAs', 'Audit Wage Reports', 'Manage Wage Reports', 'Create Wage Reports', 'Amend Wage Reports', 'Assign TPA', 'Manage Employer Details', 'Manage TPA Details']

roles.each do |role|
Role.create(name: role)
end

keys.each do |key|
  FilterToken.create(name: key, granted: false)
end


puts "Creating Indexes"
system "rake db:mongoid:create_indexes"
puts "::: complete :::"

puts "End of Seed Data"

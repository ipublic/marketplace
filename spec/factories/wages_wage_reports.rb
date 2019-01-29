FactoryBot.define do
  factory :wages_wage_report, class: 'Wages::WageReport' do

    submission_kind			{ :original }
    filing_method_kind  { :upload }
		total_wages	        { 40_125.32 }
		excess_wages	      {  5_125.11 }
		taxable_wages	      { total_wages - excess_wages }

		association					:wage_entries
		association					:organization_party
    association					:timespans
  end
end

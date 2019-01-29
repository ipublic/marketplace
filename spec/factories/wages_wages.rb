FactoryBot.define do
  factory :wages_wage, class: 'Wages::Wage' do
  	
		association	:person_party
		state_qtr_ui_total_wages		{ 40_125.32 }
		state_qtr_ui_excess_wages		{  5_125.11 }
		state_qtr_ui_taxable_wages	{ state_qtr_ui_total_wages - state_qtr_ui_excess_wages }
    
  end
end

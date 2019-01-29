# ICESA Record format used by DC DOES Unemployment Insurance group
module Integrations
	class UiIceasa
	  include Mongoid::Document

		def dsl
			# Record Length: 275 chars
			# Deliminiators: CRLF (0D0A in hex) at end of each record - positions 276 & 277
			Slither.define :simple, :by_bytes => false do |d|

				d.template :address do |t|
					t.field	:name,							length: 50, type: :string,	required: true
					t.field	:street_address,		length: 40, type: :string,	required: true
					t.field	:city,							length: 25, type: :string,	required: true
					t.field	:state,							length:  2,	type: :string,	required: true
				end

				d.template :zip_code do |t|
					t.field	:zip_code,					length:  5,	type: :string,	required: true
					t.field	:zip_extension,			length:  5,	type: :string,	required: false # include hyphen in position 159
				end

				d.template :phone do |t|
					t.field	:contact_phone,			length: 10,	type: :string,	required: true 
					t.field	:contact_phone_ext,	length:  4,	type: :string,	required: true 
				end


			# Record types
				# Transmitter
				d.transmitter do |transmitter|
					transmitter.field :record_id, 										length:  1,	type: :string, 	required: true, default: 'A' # constant
					transmitter.field :year, 													length:  4,	type: :integer,	required: true 	# CCYY
					transmitter.field :transmitter_fein,							length:  9,	type: :integer, required: true
					transmitter.field :taxing_entity_code,						length:  4,	type: :string, 	required: true, default: 'UTAX' # constant
					transmitter.field	:spacer,												length:  5

					transmitter.template :address
					transmitter.field	:spacer,												length: 13
					transmitter.template :zip_code

					transmitter.field	:transmitter_contact,						length: 30,	type: :string,	required: true 	
					transmitter.field	:transmitter_contact_phone,			length: 10,	type: :string,	required: true 
					transmitter.field	:transmitter_contact_phone_ext,	length:  4,	type: :string,	required: true 
					transmitter.field	:media_transmittter_auth_nbr,		length:  6,	type: :string,	required: false 
					transmitter.field	:c3_data,												length:  1,	type: :string,	required: false 
					transmitter.field	:suffix_code,										length:  5,	type: :string,	required: false 
					transmitter.field	:allocation_lists,							length:  1,	type: :string,	required: false 
					transmitter.field	:service_agent_id,							length:  9,	type: :string,	required: false 
					transmitter.field	:total_remittance_amount,				length: 13,	type: :string,	required: false 
					transmitter.field	:media_creation_date,						length:  8,	type: :string,	required: true  # MMDDYYYY
					transmitter.field	:spacer,												length: 25
				end


				# Authorization
				d.authorization do |authorization|
					authorization.field 		:record_id, 													length:  1,	type: :string, 	required: true, default: 'B' # constant

				end



				# Employer
				d.employer do |employer|
					employer.field 		:record_id, 																length:  1,	type: :string, 	required: true, default: 'E' # constant
					employer.field 		:payment_year, 															length:  4,	type: :integer,	required: true 	# CCYY
					employer.field 		:fein,																			length:  9,	type: :integer, required: true
					employer.field 		:spacer,																		length:  9

					employer.template :address
					employer.field		:spacer,																		length:  8
					employer.template :zip_code

					employer.field 		:spacer,																		length:  1

					employer.field 		:type_of_employment,												length:  1, type: :string, required: false

					employer.field 		:blocking_factor,														length:  1, type: :string, required: false
					employer.field 		:establishment_nbr_or_coverage_group_pru,		length:  1, type: :string, required: false
					employer.field 		:taxing_entity_code,												length:  4,	type: :string, required: true, default: 'UTAX' # constant
					employer.field 		:state_identifier_code,											length:  2, type: :string, required: true, default: '11' # DC = 11
					employer.field 		:state_unemployment_insurance_account_nbr,	length: 15, type: :string, required: true # left justify with trailing spaces

					employer.field 		:reporting_period,													length:  2, type: :string, required: true
					employer.field 		:no_workers_no_wages,												length:  1, type: :string, required: true
					employer.field 		:tax_type_code,															length:  1, type: :string, required: false
					employer.field 		:other_taxing_entity_code,									length:  5, type: :string, required: false
					employer.field 		:state_control_number,											length:  7, type: :string, required: false
					employer.field 		:unit_number,																length:  5, type: :string, required: false

					employer.field 		:spacer,																		length: 47
					employer.field 		:foreign_indicator,													length:  1, type: :string, required: true
					employer.field 		:spacer,																		length:  1
					employer.field 		:other_ein,																	length:  9, type: :string, required: false
					employer.field 		:spacer,																		length:  9
				end



				# Employees
				d.employees do |employee|
					employee.field 		:record_id, 																					length:  1,	type: :string, 	required: true, default: 'S' # constant
					employee.field 		:social_security_nbr, 																length:  1,	type: :string, 	required: true
					employee.field 		:last_name, 																					length:  1,	type: :string, 	required: true
					employee.field 		:first_name, 																					length:  1,	type: :string, 	required: true
					employee.field 		:middle_initial, 																			length:  1,	type: :string, 	required: true

					employee.field 		:state_identifier_code,																length:  2, type: :string, required: true, default: '11' # DC = 11
					employee.field 		:spacer,																							length:  4

					employee.field 		:state_qtr_total_gross_wages,													length:  2, type: :money, required: false
					employee.field 		:state_qtr_unemployment_insurance_total_wages,				length:  2, type: :money, required: true
					employee.field 		:state_qtr_unemployment_insurance_excess_wages,				length:  2, type: :money, required: true
					employee.field 		:state_qtr_unemployment_insurance_taxable_wages,			length:  2, type: :money, required: true
					employee.field 		:quarterly_state_disability_insurance_taxable_wages,	length:  2, type: :money, required: false
					employee.field 		:quarteraly_tip_wages,																length:  2, type: :money, required: false
					employee.field 		:nbr_of_weeks_worked,																	length:  2, type: :string, required: false
					employee.field 		:nbr_of_hours_worked,																	length:  2, type: :string, required: false

					employee.field 		:spacer,																							length:  4

					employee.field 		:taxing_entity_code,																	length:  4,	type: :string, required: true, default: 'UTAX' # constant
					employee.field 		:state_unemployment_insurance_account_nbr,						length: 15, type: :string, required: true
					employee.field 		:unit_division_location_plant_code,										length: 15, type: :string, required: false

					employee.field 		:state_taxable_wages,																	length: 14, type: :money, required: false
					employee.field 		:state_income_tax_withheld,														length: 14, type: :money, required: false
					employee.field 		:seasonal_indicator,																	length:  2, type: :string, required: false
					employee.field 		:employee_health_insurance_code,											length:  1, type: :string, required: false
					employee.field 		:employer_health_insurance_code,											length:  1, type: :string, required: false
					employee.field 		:probationary_code,																		length:  1, type: :string, required: false
					employee.field 		:officer_code,																				length:  1, type: :string, required: false
					employee.field 		:wage_plan_code,																			length:  1, type: :string, required: false
					employee.field 		:month_1_employment,																	length:  1, type: :string, required: false
					employee.field 		:month_2_employment,																	length:  1, type: :string, required: false
					employee.field 		:month_3_employment,																	length:  1, type: :string, required: false
					employee.field 		:reporting_quarter_and_year,													length:  6, type: :string, required: true
					employee.field 		:date_first_employed,																	length:  6, type: :string, required: false
					employee.field 		:date_of_separation,																	length:  6, type: :string, required: false

					employee.field 		:spacer,																							length: 43
				end

				# Total
				d.total do |total|
					total.field :record_id, 																									length:  1,	type: :string, 	required: true, default: 'T' # constant
					total.field :total_nbr_of_employees,  																		length:  7, type: :integer, required: true
					total.field :taxing_entity_code,																					length:  4,	type: :string, required: true, default: 'UTAX' # constant

					total.field :state_qtr_total_gross_wages_for_employer, 										length: 14, type: :money, required: true
					total.field :state_qtr_unemployment_insurance_total_wages_for_employer,		length: 14, type: :money, required: true
					total.field :state_qtr_unemployment_insurance_excess_wages_for_employer,	length: 14, type: :money, required: true
					total.field :state_qtr_unemployment_insurance_taxable_wages_for_employer,	length: 14, type: :money, required: true
					total.field :quarteraly_tip_wages_for_employer, 													length: 13, type: :integer, required: false
					total.field :ui_tax_rate_this_quarter, 																		length:  6, type: :percent, required: true
					total.field :state_qtr_ui_taxes_due, 																			length: 13, type: :string, required: true
					total.field :previous_quarters_underpayment, 															length: 11, type: :string, required: true
					total.field :interest, 																										length: 11, type: :string, required: true
					total.field :penalty, 																										length: 11, type: :string, required: true
					total.field :credit_overpayment, 																					length: 11, type: :string, required: false
					total.field :employer_assesstment_rate, 																	length:  5, type: :percent, required: false
					total.field :employer_assessment_amount, 																	length: 11, type: :string, required: true
					total.field :employee_assessment_rate, 																		length:  4, type: :string, required: false
					total.field :employee_assessment_amount, 																	length: 11, type: :string, required: false
					total.field :total_remittance_amount, 																		length: 11, type: :string, required: true
					total.field :allocation_amount, 																					length: 13, type: :string, required: false
					total.field :wages_subject_to_state_income_tax, 													length: 14, type: :string, required: false
					total.field :state_income_tax_withheld, 																	length: 14, type: :string, required: false
					total.field :month_1_employment_for_employer, 														length:  7, type: :integer, required: true
					total.field :month_2_employment_for_employer, 														length:  7, type: :integer, required: true
					total.field :month_3_employment_for_employer, 														length:  7, type: :integer, required: true
					total.field :county_code, 																								length:  3, type: :string, required: false
					total.field :outside_county_employees, 																		length:  7, type: :string, required: false
					total.field :document_control_number, 																		length: 10, type: :string, required: false

					total.field :spacer,																											length:  8
				end

				# Final
				d.final do |final|
					final.field 		:record_id, 																					length:  1,	type: :string, 	required: true, default: 'F' # constant

				end
			end

		end


	end
end

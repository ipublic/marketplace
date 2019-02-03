puts "*"*80
puts "Populating Roles"
puts "*"*80

## PersonParty Roles ##
Parties::PartyRoleKind.create!(key: :employee, title: 'Employee')
Parties::PartyRoleKind.create!(key: :owner_or_officer, title: 'Owner/Officer')
Parties::PartyRoleKind.create!(key: :contractor, title: 'Contractor')

Parties::PartyRoleKind.create!(key: :responsible_party, title: 'Responsible Party')
Parties::PartyRoleKind.create!(key: :self, title: 'Self')
Parties::PartyRoleKind.create!(key: :spouse, title: 'Spouse')
Parties::PartyRoleKind.create!(key: :domestic_partner, title: 'Domestic Partner')
Parties::PartyRoleKind.create!(key: :child, title: 'Child')
Parties::PartyRoleKind.create!(key: :dependent, title: 'Dependent')

Parties::PartyRoleKind.create!(key: :contact, title: 'Contact')

# UITS/PFL 
Parties::PartyRoleKind.create!(key: :ui_claiment, title: 'Unemployment Insurance Claiment')
Parties::PartyRoleKind.create!(key: :pfl_claiment, title: 'Paid Family Leave Claiment')


## OrganizationParty Roles ##
Parties::PartyRoleKind.create!(key: :parent_organization, title: 'Parent Organization')
Parties::PartyRoleKind.create!(key: :subsiary, title: 'Subsiary')
Parties::PartyRoleKind.create!(key: :department, title: 'Department')
Parties::PartyRoleKind.create!(key: :division, title: 'Division')
Parties::PartyRoleKind.create!(key: :internal_organization, title: 'Internal Organization')
Parties::PartyRoleKind.create!(key: :other_organization_unit, title: 'Other Organization Unit')
Parties::PartyRoleKind.create!(key: :employer, title: 'Employer')

# Site Owner is super user across system -- only assign to one organization
Parties::PartyRoleKind.create!(key: :site_owner, title: 'Site Owner')

# Corporate Entity Kinds
Parties::PartyRoleKind.create!(key: :s_corporation, title: 'S Corporation')
Parties::PartyRoleKind.create!(key: :c_corporation, title: 'C Corporation')
Parties::PartyRoleKind.create!(key: :limited_liability_corporation, title: 'Limited Liability Corporation')
Parties::PartyRoleKind.create!(key: :limited_liability_partnership, title: 'Limited Liability Partnership')
Parties::PartyRoleKind.create!(key: :non_profit_501c3, title: 'Non Profit 501c(3) Corporation')
Parties::PartyRoleKind.create!(key: :other_non_profit, title: 'Other Non Profit')
Parties::PartyRoleKind.create!(key: :household_employer, title: 'Household Employer')
Parties::PartyRoleKind.create!(key: :regulatory_agency, title: 'Regulatory Agency')

# UITS/PFL 
Parties::PartyRoleKind.create!(key: :tpa, title: 'Third Party Administrator')
Parties::PartyRoleKind.create!(key: :tpa_agent, title: 'TPA Agent')

Parties::PartyRoleKind.create!(key: :uits_liable, title: 'Unemployment Insurance Tax Liable')
Parties::PartyRoleKind.create!(key: :uits_exempt, title: 'Unemployment Insurance Tax Exempt')
Parties::PartyRoleKind.create!(key: :uits_contributing, title: 'UI Tax Contribution Payment Model')
Parties::PartyRoleKind.create!(key: :uits_reimbursing, title: 'UI Tax Reimbursement Payment Model')
Parties::PartyRoleKind.create!(key: :uits_qtr_filer, title: 'UI Tax Quarterly Filer')
Parties::PartyRoleKind.create!(key: :uits_annual_filer, title: 'UI Tax Annual Filer')

Parties::PartyRoleKind.create!(key: :pfl_liable, title: 'Paid Family Leave Tax Liable')
Parties::PartyRoleKind.create!(key: :pfl_exempt, title: 'Paid Family Leave Tax Exempt')
Parties::PartyRoleKind.create!(key: :pfl_opt_in, title: 'Paid Family Leave Tax Opted-In')


puts "*"*80
puts "Populating Relationships"
puts "*"*80

Parties::PartyRelationshipKind.create!( key: :employment, title: 'Employment',
                                        party_role_kinds: [
                                            Parties::PartyRoleKind.find_by(key: :employee),
                                            Parties::PartyRoleKind.find_by(key: :employer),
                                          ]
                                      )

Parties::PartyRelationshipKind.create!( key: :organization_officer, title: 'Organization Officer',
                                        party_role_kinds: [
                                            Parties::PartyRoleKind.find_by(key: :parent_organization),
                                            Parties::PartyRoleKind.find_by(key: :owner_or_officer),
                                          ]
                                      )

Parties::PartyRelationshipKind.create!( key: :organization_ui_primary_contact, title: 'Organization UI Primary Contact',
                                        party_role_kinds: [
                                            Parties::PartyRoleKind.find_by(key: :contact),
                                            Parties::PartyRoleKind.find_by(key: :parent_organization),
                                          ]
                                      )

Parties::PartyRelationshipKind.create!( key: :organization_ui_secondary_contact, title: 'Organization UI Secondary Contact',
                                        party_role_kinds: [
                                            Parties::PartyRoleKind.find_by(key: :contact),
                                            Parties::PartyRoleKind.find_by(key: :parent_organization),
                                          ]
                                      )

Parties::PartyRelationshipKind.create!( key: :organization_pfl_primary_contact, title: 'Organization PFL Primary Contact',
                                        party_role_kinds: [
                                            Parties::PartyRoleKind.find_by(key: :contact),
                                            Parties::PartyRoleKind.find_by(key: :parent_organization),
                                          ]
                                      )

Parties::PartyRelationshipKind.create!( key: :organization_pfl_secondary_contact, title: 'Organization PFL Secondary Contact',
                                        party_role_kinds: [
                                            Parties::PartyRoleKind.find_by(key: :contact),
                                            Parties::PartyRoleKind.find_by(key: :parent_organization),
                                          ]
                                      )

Parties::PartyRelationshipKind.create!( key: :ui_tpa_relationship, title: 'UI TPA Relationship',
                                        party_role_kinds: [
                                            Parties::PartyRoleKind.find_by(key: :tpa),
                                            Parties::PartyRoleKind.find_by(key: :employer),
                                          ]
                                      )

Parties::PartyRelationshipKind.create!( key: :pfl_tpa_relationship, title: 'PFL TPA Relationship',
                                        party_role_kinds: [
                                            Parties::PartyRoleKind.find_by(key: :tpa),
                                            Parties::PartyRoleKind.find_by(key: :employer),
                                          ]
                                      )





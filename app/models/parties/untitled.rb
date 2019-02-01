  # :dan :employee has: :employment (relationship) with :ideacrew as: :employer

  employee_role_kind   = Parties::PartyRoleKind.create!(title: 'Employee')
  employee_role = Parties::PartyRole.create!(party_role_kind: employee_role_kind)

  employer_role_kind   = Parties::PartyRoleKind.create!(title: 'Employer')
  employer_role = Parties::PartyRole.create!(party_role_kind: employer_role_kind)

  employment_relationship_kind = Parties::PartyRelationshipKind.create!(key: :employment, title: 'Employment', role_kinds: [employer_role_kind, employee_role_kind])

  employee        = Parties::PersonParty.new(current_first_name: 'mary', current_last_name: 'poppins')
  organization_1  = Parties::OrganizationParty.new(legal_name: 'ACME Nannies, Inc.', fein: '258147894', entity_kind: :s_corporation, is_foreign_entity: true)
  organization_2  = Parties::OrganizationParty.new(legal_name: 'Simpsons, Inc.', fein: '698725879', entity_kind: :c_corporation, is_foreign_entity: true)

  employee.add_party_role(employee_role_kind)
  employer.add_party_role(employer_role_kind)

  organization_employment_related_party_kind
  employment      = Parties::PartyRoleKind.new(title: 'Employment', related_party_kind: employer_kind)



  Parties::PartyRole.new(party: employee, party_role_kind: employee_kind)
  Parties::PartyRole.new(party: employee, party_role_kind: employee_kind)
  Parties::PartyRole.new(party: organization, party_role_kind: employer_kind)

  employee.party_roles = [organization_1, organization_2]

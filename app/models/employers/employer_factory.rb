module Employers
  class EmployerFactory
		def self.call(contact_info:, employer_info:, address_info:)
      employer = Parties::OrganizationParty.new(legal_name: employer_info.legal_name, fein: employer_info.fein, entity_kind: employer_info.kind.to_sym, is_foreign_entity: false)
      employee = Parties::PersonParty.new(current_first_name: contact_info.first_name, current_last_name: contact_info.last_name)

      #employee_party_role = Parties::PartyRole.new(party_role_kind: employee_party_role_kind, role_castable: employer)
      #employee.add_party_role(employee_party_role)
      [employee, employer]
    end

    def self.employee_party_role_kind
      @employee_party_role_kind ||= Parties::PartyRoleKind.find_by!(key: :employee)
    end

    def self.employer_party_role_kind
      @employer_party_role_kind ||= Parties::PartyRoleKind.find_by!(key: :employer)
    end

    def self.employment_party_relationship_kind
      @employment_party_relationship_kind ||= Parties::PartyRelationshipKind.find_by!(key: :employment)
    end
  end
end

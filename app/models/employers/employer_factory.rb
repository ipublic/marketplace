module Employers
  class EmployerFactory
		def self.call(contact_info:, employer_info:, address_info:)
      employer = Parties::OrganizationParty.new(legal_name: employer_info.legal_name, fein: employer_info.fein, entity_kind: employer_info.kind.to_sym, is_foreign_entity: false)
      contact = Parties::PersonParty.new(current_first_name: contact_info.first_name, current_last_name: contact_info.last_name)

      relationship_party = Roles::RelationshipRoleFactory.new(contact, :contact, :organization_ui_primary_contact, employer).party

      if Parties::PartyRoleKind.is_valid_key?(employer_info.kind.to_sym)
        role = Roles::RoleFactory.new(employer, employer_info.kind.to_sym).party_role
      end

      financial_account = FinancialAccounts::FinancialAccountFactory.call(employer, account_kind: :ui_financial_account)

      #employee_party_role = Parties::PartyRole.new(party_role_kind: employee_party_role_kind, role_castable: employer)
      #employee.add_party_role(employee_party_role)
      [contact, employer, employer.party_ledger, relationship_party, role, financial_account].compact
    end

    def self.contact_role_kind
      @employee_party_role_kind ||= Parties::PartyRoleKind.find_by!(key: :contact)
    end

    def self.party_relationship_kind
      @employment_party_relationship_kind ||= Parties::PartyRelationshipKind.find_by!(key: :organization_ui_primary_contact)
    end
  end
end

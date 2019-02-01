require 'rails_helper'

RSpec.describe Employers::EmployerForm do
  describe Employers::EmployerForm do
    describe "##for_create" do
      let(:contact_info) do
        { :first_name => 'Silky',
          :last_name => 'Johnston',
          :dob => '09/22/1981',
          :email => 'silky@coffee.com',
          :area_code => '202',
          :number => '222-2222' }
      end

      let(:employer_info) do
        { :legal_name => "Silky's Coffee",
          :dba => '0234232',
          :fein => '123456789',
          :kind => 'C Corpation' }
          #:sic_code, String
      end

      let(:address_info) do
        { :kind => 'primary',
          :address_1 => '202 2nd St',
          :address_2 => '',
          :city => 'Washington',
          :state => 'DC',
          :zip => '20002',
          :area_code => '202',
          :number => '222-2222',
          :extension => '' }
      end

      before do
        Parties::PartyRoleKind.create!(key: :employee, title: 'Employee')
        Parties::PartyRoleKind.create!(key: :employer, title: 'Employer')
        Parties::PartyRelationshipKind.create!(key: :employment, title: 'Employment',
                                              party_role_kinds: [
                                                  Parties::PartyRoleKind.find_by!(key: :employee),
                                                  Parties::PartyRoleKind.find_by!(key: :employer)
                                                ]
                                              )
      end

      subject do
        Employers::EmployerForm.for_create(contact_info: contact_info, employer_info: employer_info, address_info: address_info)
      end

      it 'creates a new employer party' do
        expect(subject).to be_a(Employers::EmployerForm)
      end

      it 'can be saved and creates a new instance' do
        expect { subject.save }.to change { Parties::Party.all.count }.by(1)
      end
    end
  end
end

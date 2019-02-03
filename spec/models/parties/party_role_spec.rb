require 'rails_helper'

RSpec.describe Parties::PartyRole, type: :model, dbclean: :after_each do
    it { is_expected.to be_mongoid_document }
		it { is_expected.to have_timestamps }

    # it { is_expected.to belong_to(:person_party)}
    it { is_expected.to belong_to(:party_role_kind)}
    it { is_expected.to belong_to(:role_castable)}

    it { is_expected.to have_fields(:start_date, :end_date)}

    let(:key)														{ :hero }
    let(:title)													{ "Hero" }
    let(:party_role_kind)								{ Parties::PartyRoleKind.create!(key: key) }
    let(:scott_pilgrim_person_party)		{ Parties::PersonParty.new(current_first_name: 'Scott', current_last_name: 'Pilgrim') }

	  let(:params) do
	    {
	      party_role_kind: party_role_kind,
	      role_castable: scott_pilgrim_person_party,
	    }
	  end

	  describe "A new model instance" do

	    context "with no arguments" do
				subject { described_class.new }

        it "should not be valid" do
          subject.validate
          expect(subject).to_not be_valid
          expect(subject.errors[:party_role_kind].first).to match(/can't be blank/)
        end
	    end

      context "with no party_role_kind" do
        subject { described_class.new(params.except(:party_role_kind)) }

        it "should not be valid" do
          subject.validate
          expect(subject).to_not be_valid
          expect(subject.errors[:party_role_kind].first).to match(/can't be blank/)
        end
      end

      context "with no polymorphic role_castable" do
        subject { described_class.new(params.except(:role_castable)) }

        it "should not be valid" do
          subject.validate
          expect(subject).to_not be_valid
          expect(subject.errors[:role_castable].first).to match(/can't be blank/)
        end
      end

      context "with all required arguments" do
        subject {described_class.new(params) }

        it "should be valid" do
          subject.validate
          expect(subject).to be_valid
        end

        it "should have access to delegated attributes" do
        	expect(subject.key).to eq key
        	expect(subject.title).to eq title
        end

        it "should be active" do
        	expect(subject.is_active?).to be_truthy 
        end

      end
	  end

end

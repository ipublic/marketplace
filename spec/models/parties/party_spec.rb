require 'rails_helper'

RSpec.describe Parties::Party, type: :model do
  it { is_expected.to be_mongoid_document }
  it { is_expected.to have_timestamps }

  it { is_expected.to have_fields(:party_id, :registered_on, :profile_source, :contact_method)}

  it { is_expected.to embed_many(:documents)}

  it { is_expected.to have_one(:party_ledger)}
  it { is_expected.to have_many(:party_ledger_account_balances)}
  it { is_expected.to have_many(:determinations)}
  it { is_expected.to have_many(:cases)}
  it { is_expected.to have_many(:notices)}


  describe "A new Party model instance" do

    context "with no arguments" do
      subject { described_class.new }

      it "should be valid" do
        subject.validate
        expect(subject).to be_valid
      end

    end
  end

  describe "Managing Roles and Relationships" do
    context "Given a new Party model instance" do
      subject { described_class.new }

      it "party_roles set should be empty" do
        expect(subject.party_roles.count).to eq 0
      end

      context "and a declarative PartyRole is added" do
        let(:key)                           { :hero }
        let(:title)                         { "Hero" }
        let(:party_role_kind)               { Parties::PartyRoleKind.create!(key: key) }
        let(:party_role)                    { Parties::PartyRole.new(party_role_kind: party_role_kind) }
        let(:scott_pilgrim_person_party)    { Parties::PersonParty.new(current_first_name: 'Scott', current_last_name: 'Pilgrim') }

        # before { subject.add_party_role(:happy_camper_party_role) }


        it "should be findable by matching party_role_kind" do
        end


        it "should be valid" do
          subject.validate
          expect(subject).to be_valid
        end
      end

      context "and a PartyRole with Relationship and Related Party is added" do
      end
    end

  end


end

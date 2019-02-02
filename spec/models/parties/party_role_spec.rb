require 'rails_helper'

RSpec.describe Parties::PartyRole, type: :model do
    it { is_expected.to be_mongoid_document }
			it { is_expected.to have_timestamps }

    it { is_expected.to be_embedded_in(:party)}

    it { is_expected.to have_fields(:party_role_kind_id, :related_party_id, :start_date, :end_date)}

    let(:key)									{ :happy_camper }
    let(:title)								{ "Happy Camper" }
    let(:party_role_kind)			{ Parties::PartyRoleKind.create!(key: key) }
    let(:party_role_kind_id)	{ Parties::PartyRoleKind.find_by(key: key)._id }
    let(:person_party)				{ Parties::PersonParty.new(current_first_name: 'Donny', current_last_name: 'Darko') }

	  let(:params) do
	    {
	      party_role_kind: party_role_kind,
	    }
	  end

	  describe "A new model instance" do

	    context "with no arguments" do
				subject { described_class.new }

        it "should not be valid" do
          subject.validate
          expect(subject).to_not be_valid
          expect(subject.errors[:party_role_kind_id].first).to match(/can't be blank/)
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

require 'rails_helper'

RSpec.describe Parties::PartyRelationshipKind, type: :model, dbclean: :after_each do
    it { is_expected.to be_mongoid_document }
		it { is_expected.to have_timestamps }

    it { is_expected.to have_fields(:key, :title, :description)}

    let(:key)												{ :battle_opponents }
    let(:title)											{ "Battle Opponents" }

    let(:scott_pilgrim_role) 				{ Parties::PartyRoleKind.create!(key: :hero) }
    let(:bollywood_evil_ex_role)		{ Parties::PartyRoleKind.create!(key: :evil_ex) }
    let(:skateboarder_evil_ex_role)	{ Parties::PartyRoleKind.create!(key: :evil_ex) }
    let(:vegan_evil_ex_role)				{ Parties::PartyRoleKind.create!(key: :evil_ex) }
    let(:exgirlfriend_evil_ex_role)	{ Parties::PartyRoleKind.create!(key: :evil_ex) }
    let(:twin_one_evil_ex_role)			{ Parties::PartyRoleKind.create!(key: :evil_ex) }
    let(:twin_two_evil_ex_role)			{ Parties::PartyRoleKind.create!(key: :evil_ex) }
    let(:gman_evil_ex_role)					{ Parties::PartyRoleKind.create!(key: :evil_ex) }

    let(:subject_party_role_kind)		{ Parties::PartyRoleKind.create!(key: :hero) }
    let(:object_party_role_kind)		{ Parties::PartyRoleKind.create!(key: :evil_ex) }

    let(:party_role_kinds)					{ [subject_party_role_kind, object_party_role_kind] }

	  let(:params) do
	    {
	      key: key,
	      title: title,
	      party_role_kinds: party_role_kinds,
	    }
	  end

	  describe "A new model instance" do

	    context "with no arguments" do
				subject { described_class.new }

        it "should not be valid" do
          subject.validate
          expect(subject).to_not be_valid
        end
	    end

      context "with both key and title" do
        let(:other_key)   { :other_key }
        let(:other_title) { 'other_title' }
        subject { described_class.new(key: other_key, title: other_title) }

        it "should set the assigned values" do
          subject.validate
          expect(subject.key).to eq other_key
          expect(subject.title).to eq other_title
        end
      end

      context "with no key and no title" do
        subject { described_class.new(params.except(*[:key, :title])) }

        it "should not be valid" do
          subject.validate
          expect(subject).to_not be_valid
          expect(subject.errors[:key].first).to match(/can't be blank/)
        end
      end

      context "with a key and no title" do
        subject { described_class.new(params.except(:title)) }

        it "should be valid" do
          subject.validate
          expect(subject).to be_valid
        end
      end

      context "with a title and no key" do
        subject { described_class.new(params.except(:key)) }

        it "should be valid" do
          subject.validate
          expect(subject).to be_valid
        end
      end

      context "with no party_role_kinds" do
        subject { described_class.new(params.except(:party_role_kinds)) }

        it "should be valid" do
          subject.validate
          expect(subject).to_not be_valid
          expect(subject.errors[:party_role_kinds].first).to match(/must provide a specific role pair/)
        end
      end


      context "with all required arguments" do
        subject {described_class.new(params) }

        it "should be valid" do
          subject.validate
          expect(subject).to be_valid          
        end

	      context "and it is saved" do

	        it "should save" do
	          expect(subject.save).to eq true
	        end

	        context "it should be findable" do
	          before { subject.save! }
	          it "should return the instance" do
	            expect(described_class.find(subject.id.to_s)).to eq subject
	          end
	        end
	      end
      end
	  end
end

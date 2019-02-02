require 'rails_helper'

RSpec.describe Parties::PartyRoleKind, type: :model do
    it { is_expected.to be_mongoid_document }
		it { is_expected.to have_timestamps }

    it { is_expected.to have_fields(:key, :title, :description, :is_published, :start_date, :end_date)}

    let(:key)						{ :happy_camper }
    let(:title)					{ "Happy Camper" }

	  let(:params) do
	    {
	      key: key,
	      title: title,
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

      context "with no key and a title" do
        subject { described_class.new(params.except(:key)) }

        it "should be valid" do
          subject.validate
          expect(subject).to be_valid
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

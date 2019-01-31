require 'rails_helper'

module Parties
	RSpec.describe OrganizationParty, type: :model, dbclean: :after_each do
    it { is_expected.to have_many(:wage_reports)}
    it { is_expected.to embed_many(:naics_classifications)}

	  let(:legal_name) 										{ "Acme Widgets, Inc" }
	  let(:fein) 													{ "065872626" }
	  let(:entity_kind)										{ :s_corporation }
	  let(:entity_id)											{ 234567 }
	  let(:is_foreign_entity)							{ false }

	  let(:wage_reports)									{ FactoryBot.build(:wages_wage_report) }
	  let(:determinations)								{ FactoryBot.build(:determinations_determination) }
	  let(:naics_classifications)					{ FactoryBot.build(:parties_naics_classification) }
	  let(:party_ledger)									{ FactoryBot.build(:financial_accounts_party_ledger) }
	  let(:party_ledger_account_balance)	{ FactoryBot.build(:financial_accounts_party_ledger_account_balance) }

	  let(:params) do
	    {
	      legal_name: legal_name,
	      fein: fein,
	      entity_id: entity_id,
	      entity_kind: entity_kind,
	      is_foreign_entity: is_foreign_entity,
	      # office_locations: [valid_office_location_attributes]
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

      context "with no legal_name" do
        subject { described_class.new(params.except(:legal_name)) }

        it "should not be valid" do
          subject.validate
          expect(subject).to_not be_valid
          expect(subject.errors[:legal_name].first).to match(/can't be blank/)
        end
      end

      context "with no fein" do
        subject { described_class.new(params.except(:fein)) }

        it "should not be valid" do
          subject.validate
          expect(subject).to_not be_valid
          expect(subject.errors[:fein].first).to match(/can't be blank/)
        end
      end

	   	context "with invalid fein" do
			  let(:bad_fein) {"123123"}
	      let(:invalid_params) {params.deep_merge({fein: bad_fein})}
			  let(:fein_error_message) {"#{bad_fein} is not a valid FEIN"}
        subject {described_class.new(invalid_params) }

        it "should not be valid" do
          subject.validate
          expect(subject).to_not be_valid
	        expect(subject.errors[:fein]).to eq [fein_error_message]
	      end
	    end

	    # context "with no office_locations" do
	    #   let(:params) {params.except(:office_locations)}

	    #   it "should fail validation" do
	    #     expect(Organization.create(**params).errors[:office_locations].any?).to be_truthy
	    #   end
	    # end

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
end

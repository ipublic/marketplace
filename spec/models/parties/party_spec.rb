require 'rails_helper'

RSpec.describe Parties::Party, type: :model do
      it { is_expected.to be_mongoid_document }
 			it { is_expected.to have_timestamps }

      it { is_expected.to have_fields(:party_id, :registered_on, :profile_source, :contact_method)}

      it { is_expected.to embed_many(:party_roles)}
      it { is_expected.to embed_many(:documents)}

      it { is_expected.to have_one(:party_ledger)}
      it { is_expected.to have_many(:party_ledger_account_balances)}
      it { is_expected.to have_many(:determinations)}
      it { is_expected.to have_many(:cases)}
      it { is_expected.to have_many(:notices)}
end

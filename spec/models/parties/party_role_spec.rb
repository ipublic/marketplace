require 'rails_helper'

RSpec.describe Parties::PartyRole, type: :model do
      it { is_expected.to be_mongoid_document }
 			it { is_expected.to have_timestamps }

      it { is_expected.to be_embedded_in(:party)}

      it { is_expected.to have_fields(:party_role_kind_id, :related_party_id, :start_date, :end_date)}

end

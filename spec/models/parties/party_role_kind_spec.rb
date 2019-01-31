require 'rails_helper'

RSpec.describe Parties::PartyRoleKind, type: :model do
      it { is_expected.to be_mongoid_document }
 			it { is_expected.to have_timestamps }

      it { is_expected.to have_fields(:key, :title, :description, :is_published, :start_date, :end_date)}
end

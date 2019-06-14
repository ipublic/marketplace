require 'rails_helper'

RSpec.describe Subscriptions::Subscribe, type: :model, dbclean: :after_each do

  context "A Tenant not subscribed to any features" do
    let(:tenant)  { Subscriptions::Tenant.create!(site_key: :dchbx, name: "DC HealthLink") }

    it "should not have any subscribed features" do
      expect(tenant.features.size).to eq 0
    end

    context "and a Feature is created" do
      let(:feature_key) { :aca_shop_market }
      let!(:aca_shop_market_feature)     { Subscriptions::Feature.create!(
                                             key: feature_key,
                                             title: "ACA SHOP Market",
                                             description: "ACA Small Business Health Options (SHOP) Portal"
      )}

      it "should be persisted" do
        expect(Subscriptions::Feature.find_by(key: feature_key)).to eq aca_shop_market_feature
      end

      context "and the Tenant subscribes to an existing feature" do
        let(:metadata)          { { user_id: 12345 } }
        let!(:subcribed_event)  { Subscriptions::Subscribe.call(tenant_id: tenant._id, 
                                                                feature_id: aca_shop_market_feature._id, 
                                                                metadata: metadata) }

        it "should have one subscription to the correct feature" do
          expect(tenant.features.size).to eq 1
          expect(tenant.features.first.key).to eq feature_key
        end
      end
    end
  end

end

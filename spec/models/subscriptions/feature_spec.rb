require 'rails_helper'

RSpec.describe Subscriptions::Feature, type: :model do

  describe "A new Applicatrion Feature", dbclean: :after_each do
    
    let(:aca_shop_market_key)           { :aca_shop_market }
    let(:aca_shop_market_title)         { "ACA SHOP Market" }
    let(:aca_shop_market_description)   { "ACA Small Business Health Options (SHOP) Portal" }

    let(:fehb_market_key)               { :fehb_market }
    let(:fehb_market_title)             { "Federal Employee Health Benefits Portal" }
    let(:fehb_market_description)       { "OPM sponsored benefits" }

    let(:params) do
      {
        key:          aca_shop_market_key,
        title:        aca_shop_market_title,
        description:  aca_shop_market_description,
      }
    end

    let(:aca_shop_market_feature) { ApplicationFeature.new(params) }

    it "should not be enabled" do
      expect(Flipper.enabled?(aca_shop_market_key)).to be_falsey
    end

    context "and the Feature is enabled" do

      before { Flipper.enable(aca_shop_market_key) }

      it "should be available" do
        expect(Flipper.enabled?(aca_shop_market_key)).to be_truthy
      end
    end

  end


end

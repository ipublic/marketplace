require 'rails_helper'

RSpec.describe Subscriptions::Feature, type: :model do
  let(:title)			{ "ACA SHOP" }
  let(:key)				{ :aca_shop }
  let(:description)		{ "Affordable Care Act Small Employers Portal"}

  # let(:aca_shop_feature)	{ ApplicationFeature.new(title: :title, key: :key, description: :description) }

  let(:params) do
    {
      title: title,
      key: key,
      description: description,
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

    context "with no title" do
      subject { described_class.new(params.except(:title)) }

      it "should not be valid" do
        subject.validate
        expect(subject).to_not be_valid
        expect(subject.errors[:title].first).to match(/can't be blank/)
      end
    end

    context "with no key" do
      subject { described_class.new(params.except(:key)) }

      it "should not be valid" do
        subject.validate
        expect(subject).to_not be_valid
        expect(subject.errors[:key].first).to match(/can't be blank/)
      end
    end

    context "with no description" do
      subject { described_class.new(params.except(:description)) }

      it "should not be valid" do
        subject.validate
        expect(subject).to_not be_valid
        expect(subject.errors[:description].first).to match(/can't be blank/)
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

  describe "Application Tenant association" do
    let(:fehb_title)		{ "Federal Employee Health Benefits" }
    let(:fehb_key)			{ :fehb }
    let(:fehb_description)	{ "OPM sponsored insurance" }

    # let(:)

    let(:aca_shop_feature)	{ ApplicationFeature.new(params) }
    let(:fehb_feature)		{ ApplicationFeature.new(title: :fehb_title, key: :fehb_key, description: :fehb_description) }
    let(:tenant)			{ ApplicationTenant.new() }

  end
end

require 'rails_helper'

RSpec.describe Subscriptions::Tenant, type: :model, dbclean: :after_each do

  let(:site_key)  { :dchbx }
  let(:name)      { "DC HealthLink" }

  let(:params) do
    {
      site_key: site_key,
      name:     name,
    }
  end

  context "A new Tenant"  do
    context "with no params" do
      subject { described_class.new }

      it "should not be valid", :agreggate_errors do
        subject.validate
        expect(subject).to_not be_valid
        expect(subject.errors[:site_key].first).to match(/can't be blank/)
        expect(subject.errors[:name].first).to match(/can't be blank/)
      end
    end

    context "and all, valid params" do
      subject { described_class.new(params) }

      it "should be valid" do
        subject.validate
        expect(subject).to be_valid
      end

      it "should be findable" do
        subject.save!
        expect(described_class.find(subject.id)).to eq subject
      end
    end  
  end

end

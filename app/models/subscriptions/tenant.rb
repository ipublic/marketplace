module Subscriptions
  class Tenant
    include Mongoid::Document
    include Mongoid::Timestamps

    has_many	:subscriptions,
      				class_name: 'Subscriptions::Subscription'

    field :name, type: String
    field :key,  type: Symbol

    validates_presence_of :name, :key

    def features
      Subscriptions::Feature.in(id: subscriptions.pluck(:feature_id))
    end
  end
end

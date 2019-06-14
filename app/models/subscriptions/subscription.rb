module Subscriptions
  class Subscription
    include Mongoid::Document
    include Mongoid::Timestamps

    field :code,          type: String
    field :subscribed_at, type: DateTime, default: ->{ TimeKeeper.datetime_of_record }
    field :is_active,     type: Boolean

    validates_presence_of :tenant, :feature, :subscribed_at

    belongs_to 	:tenant,
      					class_name: 'Subscriptions::Tenant'

    belongs_to	:feature,
      					class_name: 'Subscriptions::Feature'

    has_many :events, as: :event_stream , class_name: 'EventSource::EventStream'

    index({ tenant_id: 1 })
    index({ feature_id: 1 })

    def activate
    	is_active = true
    end

    def deactivate
    	is_active = false
    end

  end
end

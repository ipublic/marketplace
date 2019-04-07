module Subscriptions
  class Subscription
    include Mongoid::Document
    include Mongoid::Timestamps

    belongs_to 	:tenant,
      					class_name: 'Subscriptions::Tenant'

    belongs_to	:feature,
      					class_name: 'Subscriptions::Feature'

    field :code, 					type: String
    field :subscribed_at, type: DateTime, default: ->{ TimeKeeper.datetime_of_record }
    field :is_active,			type: Boolean

    validates_presence_of :tenant, :feature, :subscribed_at

    def activate
    	is_active = true
    end

    def deactivate
    	is_active = false
    end

  end
end

module Subscriptions
  class Subscribed < EventSource::EventStream

    data_attributes :tenant_id, :feature_id

    # Use #apply to update the source model record
    def apply(subscription)
      subscription.tenant_id       = tenant_id
      subscription.feature_id      = feature_id

      subscription
    end
  end
end

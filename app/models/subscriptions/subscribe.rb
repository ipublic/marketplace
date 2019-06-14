module Subscriptions
  class Subscribe
    include EventSource::Command

    # Attributes to track in the event and update the model
    attributes :tenant_id, :feature_id, :metadata

    private

    # Use #build_event to hook into event source framework
    def build_event
      Subscribed.new(
        tenant_id:   tenant_id,
        feature_id:  feature_id,
        metadata: metadata
      )
    end
  end
end

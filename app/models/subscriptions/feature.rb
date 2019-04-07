module Subscriptions
  class Feature
    include Mongoid::Document
    include Mongoid::Timestamps


    FEATURES = {
      aca_shop_market:        { title: "ACA SHOP Market", description: "ACA Small Business Health Options (SHOP) State Based Exchange" },
      aca_individual_market:  { title: "ACA Individual Market", description: "ACA Individual Market State Based Exchange"},
      broker_agency_portal:   { title: "Broker Agency Portal", description: "Dedicated Web portal for Broker Agencies to register and manage their customer accounts" },
      general_agency_portal:  { title: "General Agency Portal", description: "Dedicated Web portal for General Agencies to Register and support their Broker Agency accounts" },
      broker_quoting_tool:    { title: "Broker Quoting Tool", description: "" },
      notice_engine:          { title: "", description: "" },
      admin_ui_classic:       { title: "", description: "" },
      admin_ui_modern:        { title: "", description: "" },
    }

    has_many  :subscriptions,
      				class_name: 'Subscriptions::Subscription'

    field :title, 			type: String
    field :key,					type: Symbol
    field :description, type: String


    validates_presence_of :title, :key, :description

    def tenants
      Tenant.in(id: subscriptions.pluck(:tenant_id))
    end
  end
end

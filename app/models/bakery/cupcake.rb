# frozen_string_literal: true
module Bakery
  class Cupcake
    include Mongoid::Document
    include Mongoid::Timestamps

    CAKE_KINDS      = %w[ white chocolate yellow  ].freeze
    FROSTING_KINDS  = %w[ vanilla chocolate strawberry banana grape cherry coconut ].freeze

    field :cc_id, type: Integer
    field :cake
    field :frosting

    embeds_many :sprinkles, class_name: 'Bakery::Sprinkle'

    index({ cc_id: 1 })

    scope :view_window,     ->(skip_count, limit_count) { skip(skip_count).limit(limit_count) }
    scope :order_by_cc_id,  -> { order(:"cc_id".asc) }

  end
end

# frozen_string_literal: true
module Bakery
  class Sprinkle
    include Mongoid::Document

    embedded_in :cupcake, class_name: 'Bakery::Cupcake'

    COLOR_KINDS = %w[ red white blue yellow green pink orange purple black ].freeze
    SHAPE_KINDS = %w[ star circle diamond square hexagon ].freeze

    field :color
    field :shape

    def sample_sprinkle
      write_attribute(:color, COLOR_KINDS.sample)
      write_attribute(:shape, SHAPE_KINDS.sample)
      self
    end

  end
end

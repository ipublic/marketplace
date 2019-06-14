# frozen_string_literal: true

module Quanta
  # Length of time for which something lasts
  class Timespan
    include Mongoid::Document
    include Mongoid::Timestamps

    embeds_one  :duration
    has_many    :sub_timespans
  end
end

module Timespans
	class MonthTimespan < Timespan
		include Mongoid::Document

    field :title, type: String

    field :date,  type: Date
    field :month, type: Integer
    field :year,  type: Integer

    validates_presence_of :month, :year

    after_initialize :pre_allocate_document

    index({month: 1, year: 1})

  end
end

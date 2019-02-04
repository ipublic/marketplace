module Timespans

  YEAR_MAXIMUM = 2099
  YEAR_MINIMUM = 1980

  class Timespan
    include Mongoid::Document
    include Mongoid::Timestamps

    field :title,     type: String
    field :begin_on,  type: Date
    field :end_on,    type: Date
    field :type,      type: String

    has_many  :wage_reports,
              class_name: 'Wages::WageReport'

    has_many  :determinations,
              class_name: 'Determinations::Determination'

    # validates_presence_of :begin_on, :end_on
    validate :ascending_dates

    index({ title: 1}, {unique: true})

    # scope :find_on, ->(date){ where(:begin_on.lte => date, :end_on.gte => date).to_a unless date.blank?; binding.pry }
    # scope :find_on,     ->(date){ where(:begin_on.lte => date, :end_on.gte => date) unless date.blank? }
    scope :find_on,     ->(date){ where(:begin_on.lte => date, :end_on.gte => date) unless date.blank? }
    scope :find_title,  ->(compare_title){ where(:title => compare_title) unless compare_title.blank? }

    # after_validation :initialize_timespan
    after_initialize :initialize_timespan

    def predecessor
      return nil unless begin_date.present?
      preceding_timespans = self.find_on(begin_date - 1.day).entries
      preceding_timespans.size == 1 ? preceding_timespans.first : nil
    end

    def self.current_timespan
      where(:begin_on.lte => Time.now, :end_on.gte => Time.now)[1]
    end

    def self.current_quarters
      where(:begin_on.gte => (Time.now - 2.years), :end_on.lte => (Time.now + 1.years)).select{|s|s._type=="Timespans::QuarterYearTimespan"}
    end

    def self.all_quarters
      where('quarter' =>{'$in' => [1,2,3,4]}).flatten.uniq.sort{|a,b| b.begin_on - a.begin_on}
    end

    def kind
      _type.to_s.demodulize.underscore.to_sym
    end

    def between?(compare_date)
      range_present? && (compare_date.between?(begin_on, end_on)) ? true : false
    end

    def to_range
      begin_on..end_on if range_present?
    end

    alias_method :min,        :begin_on
    alias_method :max,        :end_on
    alias_method :contains?,  :between?


    private

    def range_present?
      begin_on.present? && end_on.present?
    end

    def ascending_dates
      return unless range_present?
      errors.add(:begin_on, "must be earlier than End on #{end_on}") unless (begin_on <= end_on)
    end

    private

    def initialize_timespan
    end

  end
end

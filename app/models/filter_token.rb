class FilterToken
  include Mongoid::Document

  field :name, type: String
  field :granted, type: Mongoid::Boolean, default: false
end

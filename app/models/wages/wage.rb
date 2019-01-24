class Wages::Wage
  include Mongoid::Document

  WAGE_TYPES = [:exempt, :hourly, :tip]

  field :person_party_id,						type: BSON::ObjectId
  field :uits_reporting_period_id,  type: BSON::ObjectId
  field :hours_worked,							type: Integer


end

class Products::UnemploymentInsurance
  include Mongoid::Document

  PAYMENT_TYPES 				= [:contributory]
  WAGE_FILING_SCHEDULES = [:quarterly, :annually]

  field :payment_type, 					type: Symbol
  field :wage_filing_schedule, 	type: Symbol



end

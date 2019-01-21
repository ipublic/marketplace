class Determinations::Determination
  include Mongoid::Document

  belongs_to :effective_period

  field :determination_timestamp,	type: Time


end

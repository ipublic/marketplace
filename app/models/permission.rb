class Permission
  include Mongoid::Document
  embeds_many :filter_tokens

  field :role_name, type: String
end

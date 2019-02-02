class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  PRIORITY_KINDS = [:low, :normal, :high]

  embedded_in :commentable, polymorphic: true

  field :title, 						type: String
  field :content, 					type: String
  field :priority, 					type: String, 	default: :normal
  field :is_high_priority,	type: Boolean, 	default: false
  field :tags,							type: Array,		default: []

  validates :priority,
    inclusion: { in: PRIORITY_KINDS, message: "%{value} is not a valid priority kind" },
    allow_blank: false

  def add_tag(new_tag)
  	tags << new_tag unless tags.include? new_tag
  end

  def drop_tag(old_tag)
  	tags - [old_tag]
  end

  def priority=(new_priority = :normal)
    write_attribute(:priority, new_priority)
    write_attribute(:is_high_priority, true) if new_priority == :high
  end

end

module Dispatcher
  class Workflow
    include Mongoid::Document

    belongs_to :processable, polymorphic: true

    # embeds_many


    field :tasks, type: Array, default: []

  end

end

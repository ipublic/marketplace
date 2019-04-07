module MongoidToolkit
  class ModelTree

    SYSTEM_MODEL_NAMES	= ["Mongoid::GridFs::Fs::File", "Mongoid::GridFs::Fs::Chunk", "ActionDispatch::Session::MongoidStore::Session"]
    SYSTEM_MODELS		= SYSTEM_MODEL_NAMES.reduce([]) { |model_name| mongoid_model_for(model_name) }
    PARENT_ASSOCIATIONS = [:embeds_many, :has_many, :embeds_one, :has_one]
    CHILD_ASSOCIATIONS 	= [:embedded_in, :belongs_to]

    attr_reader :value

    # TODO: update Mongoid Relations to Association (available starting v7)
    # TODO: move tree into class instance

    def initialize(value)
      @value = value
      @children = []
    end

    def <<(value)
      subtree = ModelTree.new(value)
      @children = subtree
      return subtree
    end

    class << self

      def models
        Mongoid.models
      end

      def application_models
        models - SYSTEM_MODELS
      end

      def parent_models
        application_models.reduce([]) { |list, model| list << model if parent_relations_for(model).size == 0; list }
      end

      def child_models
        application_models - parent_models
      end

      def model_class_names
        return @model_class_names if defined? @model_class_names
        @model_class_names = application_models.reduce([]) { |list, model| list << model.name }
      end

      def models_sorted
        return @models_sorted if defined? @models_sorted
        sorted_model_class_names = model_class_names.sort
        @models_sorted = sorted_model_class_names.each { |class_name| mongoid_model_for(class_name) }
      end

      def child_models_for(model)
        children = immediate_child_models_for(model)

        if children.size > 0
          [model] + children.reduce([]) { |list, child| list << child_models_for(child) }
        else
          return [model]
        end
      end

      def immediate_child_models_for(model, ordered = true)
        relation_class_names = immediate_relation_class_names_for(model).reduce([]) do |list, relation|
          relation_name = relation_class_name_for(relation)
          list << relation_name unless relation_name == model.name
          list
        end

        relation_class_names.sort! if ordered
        relation_class_names.reduce([]) { |list, class_name| list << mongoid_model_for(class_name); list.compact  }
      end

      def mongoid_model_for(class_name)
        class_name.constantize if model_class_names.include?(class_name)
      end

      def parent_relations_for(model)
        model.relations.reduce([]) { |list, relation| list << relation if CHILD_ASSOCIATIONS.include?(relation_macro_for(relation)); list }
      end

      def immediate_relation_class_names_for(model)
        model.relations.reduce([]) { |list, relation| list << relation if PARENT_ASSOCIATIONS.include?(relation_macro_for(relation)); list }
      end

      def relation_class_name_for(relation)
        relation[1].class_name
      end

      def relation_macro_for(relation)
        relation[1].macro
      end
    end

  end
end

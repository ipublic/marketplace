module Employers
  class EmployerService
    attr_accessor :factory

    def initialize(attrs={})
      @factory = Employers::EmployerFactory
    end

    def save(form)
      model_attributes = form_params_to_attributes(form)
      objects = factory.call(model_attributes)
      store(form, objects)
    end

		def form_params_to_attributes(form)
      form.attributes.except(:contribution_info)
		end

    def store(form, objects)
      objects.each do |object|
        object.save!
      end
    end
  end
end

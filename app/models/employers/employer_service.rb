module Employers
  class EmployerService
    attr_accessor :factory

    def initialize(attrs={})
      @factory = Employers::EmployerFactory
    end

    def save(form)
      model_attributes = form_params_to_attributes(form)
      sponsored_benefit = factory.call(package, model_attributes)
      store(form, sponsored_benefit)
    end
  end
end

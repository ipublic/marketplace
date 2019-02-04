module Employers
  class EmployerService
    attr_accessor :factory

    def initialize(attrs={})
      @factory = Employers::EmployerFactory
    end

    def save(form)
      model_attributes = form_params_to_attributes(form)
      employee, employer = factory.call(model_attributes)
      store(form, employee, employer)
    end

		def form_params_to_attributes(form)
      form.attributes.except(:contribution_info)
		end

    def store(form, employee, employer)
      employee.save!
      employer.save!
      #employee.party_roles.first.related_party.save #TODO: Get rid of this first
      #employee.save
    end
  end
end

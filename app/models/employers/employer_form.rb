module Employers
  class AddressInfoForm
    include Virtus.model

    attribute :kind, String
    attribute :address_1, String
    attribute :address_2, String
    attribute :city, String
    attribute :state, String
    attribute :zip, String
    attribute :area_code, Integer
    attribute :number, Integer
    attribute :extension, Integer
  end

  class ContactInfoForm
    include Virtus.model

    attribute :first_name, String
    attribute :last_name, String
    attribute :dob, Date
    attribute :email, String
    attribute :area_code, Integer
    attribute :number, Integer
  end

  class EmployerInfoForm
    include Virtus.model

    attribute :legal_name, String
    attribute :dba, String
    attribute :fein, String
    attribute :kind, String
    attribute :sic_code, String
  end

  class ContributionInfoForm
    include Virtus.model
  end

  class EmployerForm
    include Virtus.model
    include ActiveModel::Model

    attribute :address_info, Employers::AddressInfoForm
    attribute :contact_info, Employers::ContactInfoForm
    attribute :contribution_info, Employers::ContributionInfoForm
    attribute :employer_info, Employers::EmployerInfoForm

    def self.for_create(params)
      form = self.new(params)
      #form.service.load_form_metadata(form)
      form
    end

    def service
      @service ||= EmployerService.new
    end

    def persist(update: false)
      return false unless self.valid?
      save_result, persisted_object = (update ? service.update(self) : service.save(self))
      return false unless save_result
      @show_page_model = persisted_object
      true
    end

    def save
      persist
    end
  end
end

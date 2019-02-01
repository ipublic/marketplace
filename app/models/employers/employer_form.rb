# module Employers
#   class EmployerForm
#     include Virtus.model

#     attribute :contact_info, AddressInfoForm
#     attribute :contact_info, ContactInfoForm
#     attribute :contribution_info, ContributionInfoForm
#     attribute :employer_info, EmployerInfoForm

#     def self.for_create(params)
#       form = self.new(params)
#       form.service.load_form_metadata(form)
#       form
#     end

#     def service
#       @service ||= EmployerService.new
#     end

#     def persist(update: false)
#       return false unless self.valid?
#       save_result, persisted_object = (update ? service.update(self) : service.save(self))
#       return false unless save_result
#       @show_page_model = persisted_object
#       true
#     end

#     def save
#       persist
#     end
#   end

#   class ContactInfoForm
#     include Virtus.model
#   end

#   class EmployerInfoForm
#     include Virtus.model
#   end

#   class ContributionInfoForm
#     include Virtus.model
#   end
# end

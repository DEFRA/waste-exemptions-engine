# frozen_string_literal: true

module WasteExemptionsEngine
  class EditRegistration < TransientRegistration
    include CanUseEditRegistrationWorkflow

    after_initialize :copy_data_from_registration, if: :new_record?

    private

    def copy_data_from_registration
      registration = Registration.where(reference: reference).first

      attributes = registration.attributes.except("id",
                                                  "assistance_mode",
                                                  "created_at",
                                                  "updated_at",
                                                  "submitted_at")

      assign_attributes(attributes)

      copy_addresses_from_registration(registration)
      copy_people_from_registration(registration)
      copy_exemptions_from_registration(registration)
    end

    def copy_addresses_from_registration(registration)
      registration.addresses.each do |address|
        addresses << TransientAddress.new(address.attributes.except("id",
                                                                    "registration_id",
                                                                    "created_at",
                                                                    "updated_at"))
      end
    end

    def copy_people_from_registration(registration)
      registration.people.each do |person|
        people << TransientPerson.new(person.attributes.except("id",
                                                               "registration_id",
                                                               "created_at",
                                                               "updated_at"))
      end
    end

    def copy_exemptions_from_registration(registration)
      self.exemptions = registration.active_exemptions
    end
  end
end

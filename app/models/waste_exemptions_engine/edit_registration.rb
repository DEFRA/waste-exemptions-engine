# frozen_string_literal: true

module WasteExemptionsEngine
  class EditRegistration < TransientRegistration
    include CanUseEditRegistrationWorkflow

    after_initialize :copy_data_from_registration, if: :new_record?

    def registration
      @registration ||= Registration.find_by(reference: reference)
    end

    private

    def copy_data_from_registration
      attributes = registration.attributes.except("id",
                                                  "assistance_mode",
                                                  "created_at",
                                                  "updated_at",
                                                  "submitted_at")

      assign_attributes(attributes)

      copy_addresses_from_registration
      copy_people_from_registration
    end

    def copy_addresses_from_registration
      registration.addresses.each do |address|
        addresses << TransientAddress.new(address.attributes.except("id",
                                                                    "registration_id",
                                                                    "created_at",
                                                                    "updated_at"))
      end
    end

    def copy_people_from_registration
      registration.people.each do |person|
        people << TransientPerson.new(person.attributes.except("id",
                                                               "registration_id",
                                                               "created_at",
                                                               "updated_at"))
      end
    end
  end
end

# frozen_string_literal: true

module WasteExemptionsEngine
  module CanCopyDataFromRegistration
    extend ActiveSupport::Concern

    included do
      after_initialize :copy_data_from_registration, if: :new_record?
    end

    def registration
      @registration ||= Registration.find_by(reference: reference)
    end

    private

    def copy_data_from_registration
      attributes = registration.attributes.except(
        "assistance_mode",
        "created_at",
        "deregistration_email_sent_at",
        "edit_token",
        "edit_token_created_at",
        "id",
        "referring_registration_id",
        "renew_token",
        "unsubscribe_token",
        "reminder_opt_in",
        "submitted_at",
        "updated_at",
        "charged"
      )

      assign_attributes(attributes)

      copy_addresses_from_registration
      copy_temp_addresses_info_from_registration
      copy_people_from_registration
      copy_exemptions_from_registration

      save!
    end

    def copy_addresses_from_registration
      registration.addresses.each do |address|
        addresses << TransientAddress.new(
          address.attributes.except(
            "created_at",
            "id",
            "registration_id",
            "updated_at"
          )
        )
      end
    end

    def copy_temp_addresses_info_from_registration
      self.temp_operator_postcode = registration.operator_address&.postcode
      self.temp_contact_postcode = registration.contact_address&.postcode
      self.temp_site_postcode = registration.site_address&.postcode
    end

    def copy_people_from_registration
      registration.people.each do |person|
        people << TransientPerson.new(
          person.attributes.except(
            "created_at",
            "id",
            "registration_id",
            "updated_at"
          )
        )
      end
    end

    def copy_exemptions_from_registration
      self.exemptions = if respond_to?(:registration_exemptions_to_copy)
                          registration_exemptions_to_copy
                        else
                          registration.active_exemptions
                        end
    end
  end
end

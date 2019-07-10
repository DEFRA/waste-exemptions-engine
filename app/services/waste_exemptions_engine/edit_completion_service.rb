# frozen_string_literal: true

module WasteExemptionsEngine
  class EditCompletionService < BaseService
    def run(edit_registration:)
      @edit_registration = edit_registration

      ActiveRecord::Base.transaction do
        find_original_registration
        copy_data_from_edit_registration
        delete_edit_registration
      end
    end

    private

    def find_original_registration
      @registration = Registration.where(reference: @edit_registration.reference).first
    end

    def copy_data_from_edit_registration
      if registration_has_changed?
        copy_attributes
        copy_addresses
        copy_people

        save_registration_with_version
      end
    end

    def delete_edit_registration
      @edit_registration.destroy
    end

    def copy_attributes
      @registration.attributes = @edit_registration.registration_attributes
    end

    def copy_addresses
      @registration.addresses = @edit_registration.transient_addresses.map do |transient_address|
        Address.new(transient_address.address_attributes)
      end
    end

    def copy_people
      @registration.people = @edit_registration.transient_people.map do |transient_person|
        Person.new(transient_person.person_attributes)
      end
    end

    def registration_has_changed?
      @registration.changed? || @registration.related_objects_changed?(@edit_registration)
    end

    def save_registration_with_version
      @registration.paper_trail.save_with_version
    end
  end
end

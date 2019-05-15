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
      copy_attributes
      copy_addresses
      copy_exemptions
      copy_people
      @registration.save!
    end

    def delete_edit_registration
      @edit_registration.destroy
    end

    def copy_attributes
      @registration.update_attributes(@edit_registration.registration_attributes)
    end

    def copy_addresses
      @registration.addresses = []
      @edit_registration.transient_addresses.each do |transient_address|
        new_address = Address.new(transient_address.address_attributes)
        @registration.addresses << new_address
      end
    end

    def copy_exemptions
      @registration.active_exemptions = @edit_registration.exemptions
    end

    def copy_people
      @registration.people = []
      @edit_registration.transient_people.each do |transient_person|
        new_person = Person.new(transient_person.person_attributes)
        @registration.people << new_person
      end
    end
  end
end

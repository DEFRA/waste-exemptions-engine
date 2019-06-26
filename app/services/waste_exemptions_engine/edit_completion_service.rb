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
      copy_people
      save_registration_if_changed
    end

    def delete_edit_registration
      @edit_registration.destroy
    end

    def copy_attributes
      @registration.attributes = @edit_registration.registration_attributes
    end

    def copy_addresses
      @registration.addresses = []
      @edit_registration.transient_addresses.each do |transient_address|
        new_address = Address.new(transient_address.address_attributes)
        @registration.addresses << new_address
      end
    end

    def copy_people
      @registration.people = []
      @edit_registration.transient_people.each do |transient_person|
        new_person = Person.new(transient_person.person_attributes)
        @registration.people << new_person
      end
    end

    def save_registration_if_changed
      if @registration.changed?
        @registration.save!
      elsif related_objects_changed?
        @registration.paper_trail.save_with_version
      end
    end

    def related_objects_changed?
      relation_data_changed?(:addresses) || relation_data_changed?(:people)
    end

    def relation_data_changed?(object)
      original_relations = Registration.where(reference: @registration.reference).first.send(object)

      ignorable_attributes = %i[id created_at updated_at]
      old_data = original_relations.to_json(exclude: ignorable_attributes)
      new_data = @registration.send(object).to_json(exclude: ignorable_attributes)

      old_data != new_data
    end
  end
end

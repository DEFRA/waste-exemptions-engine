# frozen_string_literal: true

module WasteExemptionsEngine
  class CompareRegistrationObjectsService < BaseService
    def run(registration:, edit_registration:)
      @registration = registration
      @edit_registration = edit_registration

      objects_changed?
    end

    private

    def objects_changed?
      @objects_changed ||= address_data_changed? || people_data_changed?
    end

    def address_data_changed?
      old_data = comparable_data(@registration.addresses.order(:address_type))
      new_data = comparable_data(@edit_registration.addresses.order(:address_type))

      old_data != new_data
    end

    def people_data_changed?
      old_data = comparable_data(@registration.people.order(:first_name))
      new_data = comparable_data(@edit_registration.people.order(:first_name))

      old_data != new_data
    end

    def comparable_data(items)
      items.to_json(except: %w[id created_at updated_at registration_id transient_registration_id])
    end
  end
end

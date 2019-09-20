# frozen_string_literal: true

module WasteExemptionsEngine
  class Registration < ActiveRecord::Base
    include CanHaveRegistrationAttributes

    has_paper_trail meta: { json: :json_for_version }

    self.table_name = "registrations"

    has_many :addresses
    has_many :people
    has_many :registration_exemptions
    has_many :exemptions, through: :registration_exemptions
    has_many(
      :active_exemptions,
      -> { WasteExemptionsEngine::RegistrationExemption.active },
      through: :registration_exemptions,
      source: :exemption
    )
    has_many(
      :expired_exemptions,
      -> { WasteExemptionsEngine::RegistrationExemption.expired },
      through: :registration_exemptions,
      source: :exemption
    )
    has_many(
      :expired_and_active_exemptions,
      -> { WasteExemptionsEngine::RegistrationExemption.where(state: %i[expired active]) },
      through: :registration_exemptions,
      source: :exemption
    )
    belongs_to :referring_registration, class_name: "Registration"
    has_one :referred_registration, class_name: "Registration", foreign_key: "referring_registration_id"

    # In this case, we have to pass the correct enum value, as `enum` will not generate the right query in this case.
    has_one :site_address, -> { where(address_type: 3) }, class_name: "Address"
    has_one :contact_address, -> { where(address_type: 2) }, class_name: "Address"
    has_one :operator_address, -> { where(address_type: 1) }, class_name: "Address"
    accepts_nested_attributes_for :site_address
    accepts_nested_attributes_for :contact_address
    accepts_nested_attributes_for :operator_address

    after_create :apply_reference

    has_secure_token :renew_token

    def in_renewal_window?
      (expires_on - renewal_window_before_expiry_in_days.days) < Time.now &&
        !past_renewal_window?
    end

    def past_renewal_window?
      (expires_on + renewal_window_after_expiry_in_days.days) < Date.current
    end

    def already_renewed?
      referred_registration.present?
    end

    def renewal?
      referring_registration.present?
    end

    private

    def apply_reference
      self.reference = format("WEX%06d", id)
      save!
    end

    def json_for_version
      to_json(include: %i[addresses
                          people
                          registration_exemptions])
    end

    def renewal_window_before_expiry_in_days
      WasteExemptionsEngine.configuration.renewal_window_before_expiry_in_days.to_i
    end

    def renewal_window_after_expiry_in_days
      WasteExemptionsEngine.configuration.renewal_window_after_expiry_in_days.to_i
    end

    def expires_on
      @_expires_on ||= registration_exemptions.pluck(:expires_on).presence&.sort&.first
    end
  end
end

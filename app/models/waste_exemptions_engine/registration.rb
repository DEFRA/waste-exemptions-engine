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
    belongs_to :referring_registration, class_name: "Registration"
    has_one :referred_registration, class_name: "Registration", foreign_key: "referring_registration_id"

    after_create :apply_reference

    has_secure_token :renew_token

    def in_renewal_window?
      (expires_on - renewal_window_before_expiry_in_days.days) < Time.now &&
        !past_renewal_window?
    end

    def past_renewal_window?
      (expires_on + renewal_window_after_expiry_in_days.days) < Date.current
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

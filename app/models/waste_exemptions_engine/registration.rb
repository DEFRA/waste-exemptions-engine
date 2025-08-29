# frozen_string_literal: true

module WasteExemptionsEngine
  class Registration < ApplicationRecord
    include CanHaveRegistrationAttributes
    include CanHaveViewCertificateToken
    include CanHaveMultipleSites

    has_paper_trail meta: { json: :json_for_version }

    self.table_name = "registrations"

    has_many :addresses, dependent: :destroy
    has_many :registration_communication_logs, dependent: :destroy
    has_many :communication_logs, through: :registration_communication_logs
    has_many :people, dependent: :destroy
    has_many :registration_exemptions, dependent: :destroy
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

    # For compatibility with existing single address code, returning first site address
    has_one :site_address, -> { site.order(created_at: :asc) }, class_name: "Address", dependent: :destroy
    has_one :contact_address, -> { where(address_type: 2) }, class_name: "Address", dependent: :destroy
    has_one :operator_address, -> { where(address_type: 1) }, class_name: "Address", dependent: :destroy
    has_one :account, class_name: "Account", dependent: :destroy
    accepts_nested_attributes_for :site_address
    accepts_nested_attributes_for :contact_address
    accepts_nested_attributes_for :operator_address

    after_create :apply_reference

    has_secure_token :renew_token
    has_secure_token :edit_token
    has_secure_token :unsubscribe_token

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

    def expiry_month
      expiry_date = expires_on
      return unless expiry_date.present?

      month = expiry_date.strftime("%B")
      year = expiry_date.year

      "#{month} #{year}"
    end

    def received_comms?(label)
      communication_logs.find { |log| log.template_label == label }.present?
    end

    # Temporarily exclude from coverage inspection pending resolution of SonarCloud issue
    # :nocov:
    def expires_on
      registration_exemptions.pluck(:expires_on).presence&.min
    end
    # :nocov:

    def deregistered?
      registration_exemptions.pluck(:state).excluding("ceased", "revoked").empty?
    end

    # regnerate the token and store the token timestamp
    def regenerate_and_timestamp_edit_token
      # provided by has_secure_token:
      regenerate_edit_token

      update(edit_token_created_at: Time.zone.now)
    end

    def unsubscribe_token
      return super if super.present?

      regenerate_unsubscribe_token unless new_record?
      super
    end

    private

    def apply_reference
      self.reference = format("WEX%<id>06d", id: id)
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
  end
end

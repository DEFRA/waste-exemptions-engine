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

    def too_late_to_renew?
      registration_exemptions.each do |re|
        return true if re.too_late_to_renew?
      end

      false
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
  end
end

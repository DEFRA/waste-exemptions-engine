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

    after_create :apply_reference

    has_secure_token :renew_token

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

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

    private

    def json_for_version
      to_json(include: %i[addresses
                          people])
    end
  end
end

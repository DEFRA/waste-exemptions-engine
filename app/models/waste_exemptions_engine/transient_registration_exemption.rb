# frozen_string_literal: true

module WasteExemptionsEngine
  class TransientRegistrationExemption < ActiveRecord::Base
    self.table_name = "transient_registration_exemptions"

    include CanActivateExemption

    belongs_to :transient_registration
    belongs_to :exemption

    def exemption_attributes
      attributes.except("id", "transient_registration_id", "created_at", "updated_at")
    end
  end
end

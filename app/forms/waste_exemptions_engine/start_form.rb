# frozen_string_literal: true

module WasteExemptionsEngine
  class StartForm < BaseForm
    delegate :start_option, to: :transient_registration

    validates :start_option, "waste_exemptions_engine/start": true
  end
end

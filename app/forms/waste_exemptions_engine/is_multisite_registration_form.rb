# frozen_string_literal: true

module WasteExemptionsEngine
  class IsMultisiteRegistrationForm < BaseForm
    delegate :is_multisite_registration, to: :transient_registration

    validates :is_multisite_registration, "defra_ruby/validators/true_false": true

    def minimum_sites_required
      ENV.fetch("MULTISITE_MINIMUM_SITES", WasteExemptionsEngine::CanHaveMultipleSites.minimum_sites_default).to_i
    end
  end
end

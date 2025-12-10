# frozen_string_literal: true

module WasteExemptionsEngine
  class IsMultisiteRegistrationForm < BaseForm
    delegate :is_multisite_registration, to: :transient_registration

    validates :is_multisite_registration, "defra_ruby/validators/true_false": true

    def submit(attributes)
      # For single-site, set temp_site_id to the first site address (if one exists)
      # so that site_grid_reference_form edits it instead of creating a new one
      set_temp_site_id_to_first_site if attributes[:is_multisite_registration] == "false"

      super
    end

    def minimum_sites_required
      WasteExemptionsEngine::CanHaveMultipleSites.minimum_sites_required
    end

    private

    def set_temp_site_id_to_first_site
      first_site = transient_registration.transient_addresses.where(address_type: "site").order(:created_at).first
      transient_registration.temp_site_id = first_site&.id
    end
  end
end

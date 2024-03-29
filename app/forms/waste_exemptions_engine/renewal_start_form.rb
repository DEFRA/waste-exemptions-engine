# frozen_string_literal: true

module WasteExemptionsEngine
  class RenewalStartForm < BaseForm
    delegate :company_rows, :registration_rows, to: :data_overview_presenter

    delegate :temp_renew_without_changes, to: :transient_registration

    validates :temp_renew_without_changes,
              "defra_ruby/validators/true_false": {
                messages: {
                  inclusion: I18n.t("activemodel.errors.models.waste_exemptions_engine/renewal_start_form" \
                                    ".attributes.temp_renew_without_changes.inclusion")
                }
              }

    def initialize(transient_registration)
      # When a user first renews with changes and deselects some or all
      # exemptions to renew and subsequently navigates back to renew without
      # changes we run into an edge case where exemptions do not match the
      # referring registration.  We re-assign these exemptions here to
      # correctly reset the transient registration with the correct exemptions.
      transient_registration.exemptions =
        transient_registration.registration_exemptions_to_copy

      super(transient_registration)
    end

    private

    def data_overview_presenter
      @_data_overview_presenter ||= DataOverviewPresenter.new(transient_registration)
    end
  end
end

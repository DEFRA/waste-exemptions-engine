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

    private

    def data_overview_presenter
      @_data_overview_presenter ||= DataOverviewPresenter.new(transient_registration)
    end
  end
end

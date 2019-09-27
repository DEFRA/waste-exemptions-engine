# frozen_string_literal: true

module WasteExemptionsEngine
  class RenewalStartForm < BaseForm
    include DataOverviewForm

    delegate :temp_renew_without_changes, to: :transient_registration

    validates :temp_renew_without_changes,
              "defra_ruby/validators/true_false": {
                messages: {
                  inclusion: I18n.t("activemodel.errors.models.waste_exemptions_engine/renewal_start_form"\
                                    ".attributes.temp_renew_without_changes.inclusion")
                }
              }

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      attributes = { temp_renew_without_changes: params[:temp_renew_without_changes] }

      super(attributes)
    end
  end
end

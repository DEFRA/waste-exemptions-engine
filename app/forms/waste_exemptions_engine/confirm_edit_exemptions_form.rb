# frozen_string_literal: true

module WasteExemptionsEngine
  class ConfirmEditExemptionsForm < BaseForm
    delegate :exemption_ids, :temp_confirm_exemption_edits, to: :transient_registration

    validates :temp_confirm_exemption_edits,
              "defra_ruby/validators/true_false": {
                messages: {
                  inclusion: I18n.t("activemodel.errors.models.waste_exemptions_engine/confirm_edit_exemptions_form" \
                                    ".attributes.temp_confirm_exemption_edits.inclusion")
                }
              }
  end
end

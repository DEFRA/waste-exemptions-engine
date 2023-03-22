# frozen_string_literal: true

module WasteExemptionsEngine
  class ConfirmNoExemptionChangesForm < BaseForm
    delegate :workflow_state, to: :transient_registration
    delegate :workflow_state=, to: :transient_registration

    validates :workflow_state, inclusion: {
      in: %w[deregistration_complete_no_change_form edit_exemptions_form],
      message: I18n.t("waste_exemptions_engine.confirm_no_exemption_changes_forms.new.errors.workflow_state")
    }

    def workflow_state_options_for_select
      workflow_state_struct = Struct.new(:id, :name)

      [
        workflow_state_struct.new(
          "edit_exemptions_form",
          I18n.t("waste_exemptions_engine.confirm_no_exemption_changes_forms.new.radio_no")
        ),
        workflow_state_struct.new(
          "deregistration_complete_no_change_form",
          I18n.t("waste_exemptions_engine.confirm_no_exemption_changes_forms.new.radio_yes")
        )
      ]
    end
  end
end

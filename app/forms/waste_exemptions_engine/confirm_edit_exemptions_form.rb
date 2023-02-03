# frozen_string_literal: true

module WasteExemptionsEngine
  class ConfirmEditExemptionsForm < BaseForm
    delegate :exemptions, to: :transient_registration
    delegate :workflow_state, to: :transient_registration
    delegate :workflow_state=, to: :transient_registration

    validates :workflow_state, inclusion: {
      in: %w[edit_exemptions_declaration_form edit_exemptions_form],
      message: I18n.t("waste_exemptions_engine.confirm_edit_exemptions_forms.new.errors.workflow_state")
    }

    def workflow_state_options_for_select
      workflow_state_struct = Struct.new(:id, :name)

      [
        workflow_state_struct.new(
          "edit_exemptions_declaration_form",
          I18n.t("waste_exemptions_engine.confirm_edit_exemptions_forms.new.radio_yes")
        ),
        workflow_state_struct.new(
          "edit_exemptions_form",
          I18n.t("waste_exemptions_engine.confirm_edit_exemptions_forms.new.radio_no")
        )
      ]
    end
  end
end

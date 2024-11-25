# frozen_string_literal: true

module WasteExemptionsEngine
  class ConfirmActivityExemptionsForm < BaseForm
    delegate :exemption_ids, :temp_exemptions, to: :transient_registration

    attr_accessor :temp_confirm_exemptions

    validates :temp_confirm_exemptions,
              inclusion: { in: %w[true false],
                           messages: {
                             inclusion: I18n.t("activemodel.errors.models.waste_exemptions_engine/" \
                                               "confirm_activity_exemptions_form.attributes.temp_confirm_exemptions" \
                                               ".inclusion")
                           } }

    def submit(params)
      self.temp_confirm_exemptions = params[:temp_confirm_exemptions]

      attributes = { exemption_ids: temp_exemptions }
      super(attributes)
    end
  end
end

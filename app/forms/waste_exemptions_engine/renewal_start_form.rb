# frozen_string_literal: true

module WasteExemptionsEngine
  class RenewalStartForm < BaseForm
    include DataOverviewForm

    attr_accessor :temp_renew_without_changes

    def initialize(registration)
      super
      assign_attributes_to_display
      self.temp_renew_without_changes = @transient_registration.temp_renew_without_changes
    end

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.temp_renew_without_changes = params[:temp_renew_without_changes]
      attributes = { temp_renew_without_changes: temp_renew_without_changes }

      super(attributes)
    end

    validates :temp_renew_without_changes,
              "defra_ruby/validators/true_false": {
                message: I18n.t("activemodel.errors.models.waste_exemptions_engine/renewal_start_form"\
                  ".attributes.temp_renew_without_changes.inclusion")
              }
  end
end

# frozen_string_literal: true

module WasteExemptionsEngine
  class RenewalStartForm < BaseForm
    delegate :company_rows, :registration_rows, to: :data_overview_presenter

    delegate :operator_address, :contact_address, to: :transient_registration

    validates :operator_address, "waste_exemptions_engine/address": true
    validates :contact_address, "waste_exemptions_engine/address": true

    alias company_address operator_address

    def initialize(transient_registration)
      # When a user first renews with changes and deselects some or all
      # exemptions to renew and subsequently navigates back to renew without
      # changes we run into an edge case where exemptions do not match the
      # referring registration.  We re-assign these exemptions here to
      # correctly reset the transient registration with the correct exemptions.
      unless transient_registration.temp_check_your_answers_flow?
        transient_registration.exemptions =
          transient_registration.registration_exemptions_to_copy
      end

      super
    end

    private

    def data_overview_presenter
      @_data_overview_presenter ||= DataOverviewPresenter.new(transient_registration)
    end
  end
end

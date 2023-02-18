# frozen_string_literal: true

module WasteExemptionsEngine
  class EditExemptionsForm < BaseForm
    delegate :exemptions, to: :transient_registration
    delegate :excluded_exemptions, to: :transient_registration
    delegate :registration, to: :transient_registration

    def submit(params)
      params[:exemption_ids] ||= []

      super

      transient_registration.excluded_exemptions = registration.active_exemptions
                                                               .where.not(id: exemptions.map(&:id))
                                                               .pluck(:id)
      transient_registration.save!
    end
  end
end

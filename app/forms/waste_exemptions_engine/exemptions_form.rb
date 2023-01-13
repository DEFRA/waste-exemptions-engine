# frozen_string_literal: true

module WasteExemptionsEngine
  class ExemptionsForm < BaseForm
    delegate :exemptions, to: :transient_registration

    validates :exemptions, "waste_exemptions_engine/exemptions": true

    def submit(params)
      # TODO: This line here is in order to by-pass the Rails 4 bug for which
      # empty parameters are parsed as nil.
      # This is fixed in Rails 5, so whenever we upgrade we can also get rid of this
      #
      # Update 16/12/2022: We tried removing this and it appears to still not be
      # fixed in Rails 6 and this is still required.
      params[:exemption_ids] ||= []

      super
    end
  end
end

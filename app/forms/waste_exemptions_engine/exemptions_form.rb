# frozen_string_literal: true

module WasteExemptionsEngine
  class ExemptionsForm < BaseForm
    include CanNavigateFlexibly

    attr_accessor :exemptions, :matched_exemptions, :matched_exemption_ids

    def initialize(enrollment)
      super

      # We rely on the fact that db/exemptions.csv is ordered in the way we want
      # it displayed in the UI, hence its in that order in the database.
      # This saves any unnecessary logic to try and replicate the ordering we
      # want, so we simply ensure the order is by ID, i.e. the order the
      # exemptions were seeded from the file and inserted into the table
      self.exemptions = Exemption.order(:id)
      self.matched_exemptions = @enrollment.exemptions
      self.matched_exemption_ids = matched_exemptions ? matched_exemptions.map(&:id) : []
    end

    def submit(params)
      self.matched_exemptions = determine_matched_exemptions(params)

      super({ exemptions: matched_exemptions }, params[:token])
    end

    validates :matched_exemptions, "waste_exemptions_engine/exemptions": true

    private

    def determine_matched_exemptions(params)
      return nil unless params[:exemptions]

      exemptions.select { |ex| params[:exemptions].include?(ex.id.to_s) }
    end
  end
end

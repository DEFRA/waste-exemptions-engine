# frozen_string_literal: true

module WasteExemptionsEngine
  class ExemptionParamsService < BaseService
    def run(registration:, exemption_type:, new_exemptions:)
      new_exemptions      = Array(new_exemptions)
      activity_exemptions = Array(registration.temp_activity_exemptions)
      farm_exemptions     = Array(registration.temp_farm_exemptions)
      combine_exemptions             = registration.farm_affiliated? &&
                            registration.temp_add_additional_non_farm_exemptions == true

      total_exemptions = case exemption_type
                         when :farm
                           combine_exemptions ? (activity_exemptions + new_exemptions) : activity_exemptions
                         when :activity
                           combine_exemptions ? (new_exemptions + farm_exemptions) : new_exemptions
                         else
                           new_exemptions
                         end

      { "temp_#{exemption_type}_exemptions": new_exemptions, temp_exemptions: total_exemptions.uniq }
    end
  end
end

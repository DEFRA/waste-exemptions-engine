# frozen_string_literal: true

module WasteExemptionsEngine
  class ExemptionParamsService < BaseService
    def run(registration:, exemption_type:, new_exemptions:)
      new_exemptions = Array(new_exemptions)
      activity_exemptions = Array(registration.temp_activity_exemptions)
      farm_exemptions = Array(registration.temp_farm_exemptions)
      can_combine = registration.farm_affiliated? && registration.temp_add_additional_non_farm_exemptions

      total_exemptions = case exemption_type
                         when :farm
                           if can_combine
                             (activity_exemptions + new_exemptions).uniq.sort
                           else
                             new_exemptions.sort
                           end
                         when :activity
                           if can_combine
                             (new_exemptions + farm_exemptions).uniq.sort
                           else
                             new_exemptions.sort
                           end
                         end

      { "temp_#{exemption_type}_exemptions": new_exemptions, temp_exemptions: total_exemptions }
    end
  end
end

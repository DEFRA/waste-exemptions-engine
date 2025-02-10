# frozen_string_literal: true

module WasteExemptionsEngine
  class ExemptionParamsService < BaseService
    def run(registration:, exemption_type:, new_exemptions:)
      new_exemptions = Array(new_exemptions)

      activity_exemptions = Array(registration.temp_activity_exemptions)
      farm_exemptions = Array(registration.temp_farm_exemptions)

      # Determine total exemptions based on type and settings
      total_exemptions = case exemption_type
                        when :farm
                          # Always include activity exemptions, add farm exemptions if allowed
                          if new_exemptions.empty?
                            activity_exemptions
                          elsif registration.temp_add_additional_non_farm_exemptions && registration.farm_affiliated?
                            activity_exemptions + new_exemptions
                          else
                            activity_exemptions
                          end
                        when :activity
                          # For activity exemptions, combine with farm exemptions if allowed
                          if registration.temp_add_additional_non_farm_exemptions && registration.farm_affiliated?
                            new_exemptions + farm_exemptions
                          else
                            new_exemptions
                          end
                        end.uniq

      { "temp_#{exemption_type}_exemptions": new_exemptions, temp_exemptions: total_exemptions.uniq }
    end
  end
end

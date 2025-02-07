# frozen_string_literal: true

module WasteExemptionsEngine
  class ExemptionParamsService < BaseService
    def run(registration:, exemption_type:, new_exemptions:)
      new_exemptions = Array(new_exemptions)

      total_exemptions = if registration.temp_add_additional_non_farm_exemptions && registration.farm_affiliated?
                          case exemption_type
                          when :farm
                            new_exemptions + Array(registration.temp_activity_exemptions)
                          when :activity
                            new_exemptions + Array(registration.temp_farm_exemptions)
                          end
                        else
                          new_exemptions
                        end

      {
        "temp_#{exemption_type}_exemptions".to_sym => new_exemptions,
        temp_exemptions: total_exemptions.uniq
      }
    end
  end
end

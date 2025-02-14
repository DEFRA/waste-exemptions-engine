# frozen_string_literal: true

module WasteExemptionsEngine
  class CombineExemptionsService < BaseService
    # This service combines exemption parameters (from activity and farm exemptions) based
    # on whether the transient_registration should have both or just one of the exemption
    # types.
    #
    # If a transient_registration is farm affiliated and the user has selected
    # to add additional non-farm exemptions, the service will combine the
    # exemptions from both types.
    #
    # The service returns the set of new exemptions passed in separately in all
    # cases so that they can be kept separate and the exemptions can be
    # registrered as the registration's exemptions of each type

    def run(transient_registration:, exemption_type:, new_exemptions:)
      new_exemptions = Array(new_exemptions)
      activity_exemptions = Array(transient_registration.temp_activity_exemptions)
      can_combine = transient_registration.farm_affiliated? && transient_registration.temp_add_additional_non_farm_exemptions

      total_exemptions = case exemption_type
                         when :farm
                           if can_combine
                             (activity_exemptions + new_exemptions).uniq.sort
                           else
                             new_exemptions.sort
                           end
                         when :activity
                           if can_combine
                             (new_exemptions + Array(transient_registration.temp_farm_exemptions)).uniq.sort
                           else
                             new_exemptions.sort
                           end
                         else
                           raise ArgumentError, "Invalid exemption_type: #{exemption_type}. Must be :farm or :activity"
                         end

      { "temp_#{exemption_type}_exemptions": new_exemptions, temp_exemptions: total_exemptions }
    end
  end
end

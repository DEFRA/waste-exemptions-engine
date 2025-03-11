# frozen_string_literal: true

module WasteExemptionsEngine
  module WasteActivitiesFormsHelper
    def all_categories
      WasteActivity::ACTIVITY_CATEGORIES.keys
    end

    def category_activities(category)
      WasteActivity.where(category: category)
    end

    def exemption_codes_for_activity(activity, transient_registration)
      exemptions = Exemption.for_waste_activities(activity)

      farmer_bucket = Bucket.farmer_bucket
      if farmer_bucket.present? && exclude_farming_exemptions?(transient_registration)
        exemptions = exemptions.where.not(id: farmer_bucket.exemption_ids)
      end

      exemptions.order(:code).map(&:code).join(", ")
    end

    private

    def exclude_farming_exemptions?(transient_registration)
      transient_registration.temp_add_additional_non_bucket_exemptions == true &&
        transient_registration.farm_affiliated?
    end
  end
end

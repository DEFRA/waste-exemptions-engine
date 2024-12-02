# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe WasteActivitiesForm, type: :model do
    before do
      create_list(:waste_activity, 5)
    end

    subject(:form) { build(:waste_activities_form) }
    let(:three_waste_activities) { WasteActivity.order("RANDOM()").last(3) }

    it "validates the matched waste_activities using the WasteActivitiesValidator class" do
      validators = form._validators
      expect(validators[:temp_waste_activities].first.class)
        .to eq(WasteExemptionsEngine::WasteActivitiesValidator)
    end

    it_behaves_like "a validated form", :waste_activities_form do
      let(:valid_params) { { temp_waste_activities: three_waste_activities.map(&:id).map(&:to_s) } }
      let(:invalid_params) { { temp_waste_activities: [] } }
    end

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the selected waste activities" do
          waste_activities_id_strings = three_waste_activities.map(&:id).map(&:to_s)
          valid_params = { temp_waste_activities: waste_activities_id_strings }
          transient_registration = form.transient_registration

          aggregate_failures do
            expect(transient_registration.temp_waste_activities).to be_empty
            form.submit(valid_params)
            expect(transient_registration.temp_waste_activities).to match_array(waste_activities_id_strings)
          end
        end
      end
    end
  end
end

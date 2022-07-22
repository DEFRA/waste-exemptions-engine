# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewRegistration, type: :model do
    subject(:new_registration) { create(:new_registration) }

    describe "#next_state!" do
      let(:new_registration) { build(:new_registration) }

      subject { new_registration.next_state! }

      context "with no available next state" do
        before { new_registration.workflow_state = "registration_complete_form" }

        it "does not change the state" do
          expect { subject }.not_to change { new_registration.workflow_state }
        end

        it "does not add to workflow history" do
          expect { subject }.not_to change { new_registration.workflow_history }
        end
      end

      context "with an invalid state" do
        before { new_registration.workflow_state = "not_valid" }

        it "does not change the state" do
          expect { subject }.not_to change { new_registration.workflow_state }
        end

        it "does not add to workflow history" do
          expect { subject }.not_to change { new_registration.workflow_history }
        end
      end

      context "with a valid state" do
        before { new_registration.workflow_state = "location_form" }

        it "changes the state" do
          expect { subject }.to change { new_registration.workflow_state }.to("exemptions_form")
        end

        it "adds to workflow history" do
          expect { subject }.to change { new_registration.workflow_history.length }.from(0).to(1)
        end

        it "adds the previous state to workflow history" do
          expect { subject }.to change { new_registration.workflow_history }.to(["location_form"])
        end
      end
    end

    describe "#previous_valid_state!" do
      let(:new_registration) { build(:new_registration) }

      subject { new_registration.previous_valid_state! }

      context "with no workflow history" do
        before { new_registration.workflow_history = [] }
        before { new_registration.workflow_state = "location_form" }

        it "uses the default state" do
          expect { subject }.to change { new_registration.workflow_state }.to("start_form")
        end

        it "does not modify workflow history" do
          expect { subject }.not_to change { new_registration.workflow_history }
        end
      end

      context "with partially invalid workflow history" do
        before { new_registration.workflow_history = %w[another_form location_form not_valid] }

        it "skips the invalid state" do
          expect { subject }.to change { new_registration.workflow_state }.to("location_form")
        end

        it "deletes multiple items workflow history" do
          expect { subject }.to change { new_registration.workflow_history.length }.by(-2)
        end
      end

      context "with fully invalid workflow history" do
        before do
          new_registration.workflow_state = "location_form"
          new_registration.workflow_history = %w[no_start_form not_valid]
        end

        it "uses the default state" do
          expect { subject }.to change { new_registration.workflow_state }.to("start_form")
        end

        it "deletes all items from workflow history" do
          expect { subject }.to change { new_registration.workflow_history.length }.to(0)
        end
      end

      context "with valid workflow history" do
        before do
          new_registration.workflow_history = %w[start_form location_form]
          new_registration.workflow_state = "exemptions_form"
        end

        it "changes the state" do
          expect { subject }.to change { new_registration.workflow_state }.to("location_form")
        end

        it "deletes from workflow history" do
          expect { subject }.to change { new_registration.workflow_history.length }.by(-1)
        end
      end

      context "when the current state is also in the workflow history" do
        before do
          new_registration.workflow_history = %w[start_form location_form location_form]
          new_registration.workflow_state = "location_form"
        end

        it "skips the duplicated state" do
          expect { subject }.to change { new_registration.workflow_state }.to("start_form")
        end

        it "deletes from workflow history" do
          expect { subject }.to change { new_registration.workflow_history.length }.to(0)
        end
      end
    end
  end
end

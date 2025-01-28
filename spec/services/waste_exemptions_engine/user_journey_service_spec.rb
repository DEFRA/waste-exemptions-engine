# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  module Analytics
    RSpec.describe UserJourneyService do

      describe "#run" do
        subject(:run_service) { described_class.run(transient_registration:) }

        let(:page) { "start_form" }
        let(:route) { "DIGITAL" }
        let(:transient_registration) { create(:new_registration) }
        let(:token) { transient_registration.token }
        let(:expected_journey_type) { "NewRegistration" }

        before do
          allow(WasteExemptionsEngine.configuration).to receive(:host_is_back_office?).and_return false
          allow(UserJourney).to receive(:new).and_call_original
          allow(PageView).to receive(:new).and_call_original
        end

        shared_examples "new journey" do
          let(:user_journey) { UserJourney.find_by(token: token) }
          let(:page_view) { user_journey.page_views.last }

          it { expect(UserJourney).to have_received(:new) }
          it { expect(PageView).to have_received(:new) }
          it { expect(UserJourney.last.page_views.last.page).to eq page }
          it { expect(UserJourney.last.token).to eq token }
          it { expect(UserJourney.last.journey_type).to eq expected_journey_type }
        end

        context "when a journey does not already exist for the token" do
          before { run_service }

          context "with a registration" do
            let(:transient_registration) { create(:new_registration) }
            let(:expected_journey_type) { "NewRegistration" }

            it_behaves_like "new journey"
          end

          context "with a renewal" do
            let(:transient_registration) { create(:renewing_registration, workflow_state: "renewal_start_form") }
            let(:expected_journey_type) { "RenewingRegistration" }
            let(:page) { "renewal_start_form" }

            it_behaves_like "new journey"
          end

          context "with another journey type" do
            let(:page) { "start_form" }

            before do
              test_user_journey_registration = Class.new(NewRegistration)
              stub_const("TestUserJourneyRegistration", test_user_journey_registration)
            end

            it "records the correct journey type" do
              described_class.run(transient_registration: TestUserJourneyRegistration.new(token: "foo"))

              expect(UserJourney.last.journey_type).to eq "TestUserJourneyRegistration"
            end
          end
        end

        context "when a journey already exists for the token" do
          before do
            Timecop.freeze(10.minutes.ago) { create(:user_journey, journey_type: "NewRegistration", token: transient_registration.token) }
            transient_registration.workflow_state = "location_form"

            run_service
          end

          it "does not start a new journey" do
            expect(UserJourney).to have_received(:new).once
          end

          it "updates the journey's updated_at timestamp" do
            expect(UserJourney.last.updated_at).to be > UserJourney.last.created_at
          end

          it "creates a page view" do
            expect(PageView).to have_received("new")
          end

          context "when the service is run twice consecutively for the same page" do
            before { UserJourney.last.page_views.create(page: "location_form", time: Time.zone.now, route: "DIGITAL") }

            it "is idempotent" do
              expect { described_class.run(transient_registration:) }.not_to change { UserJourney.last.reload.page_views.length }
            end
          end
        end

        context "when the latest view is a completion form" do
          shared_examples "completion form" do |form|
            before do
              transient_registration.workflow_state = form

              described_class.run(transient_registration:)
            end

            it { expect(UserJourney.last.completed_route).not_to be_nil }

            it do
              expect(UserJourney.last.registration_data).to include(
                transient_registration.attributes.slice(:business_type, :registration_type, :declared_convictions)
              )
            end
          end

          %w[
            register_in_wales_form
            register_in_scotland_form
            register_in_northern_ireland_form
            front_office_edit_complete_form
            back_office_edit_complete_form
            registration_complete_form
            private_beta_registration_complete_form
            renewal_complete_form
            deregistration_complete_full_form
          ].each do |form|
            it_behaves_like "completion form", form
          end
        end

        context "when it runs in the front office" do
          before do
            allow(WasteExemptionsEngine.configuration).to receive(:host_is_back_office?).and_return false

            described_class.run(transient_registration:)
          end

          it { expect(UserJourney.last.started_route).to eq "DIGITAL" }
          it { expect(UserJourney.last.page_views.last.route).to eq "DIGITAL" }
        end

        context "when it runs in the back office" do
          before do
            allow(WasteExemptionsEngine.configuration).to receive(:host_is_back_office?).and_return true

            described_class.run(transient_registration:)
          end

          it { expect(UserJourney.last.started_route).to eq "ASSISTED_DIGITAL" }
          it { expect(UserJourney.last.page_views.last.route).to eq "ASSISTED_DIGITAL" }
        end

        context "with a logged-in user" do
          let(:current_user) { double("user", email: "user@example.com") } # rubocop:disable RSpec/VerifiedDoubles

          it "stores the current user's email address on the user journey" do
            described_class.run(transient_registration:, current_user:)

            expect(UserJourney.last.user).to eq current_user.email
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  module Analytics

    RSpec.describe UserJourney do

      # rubocop:disable RSpec/IndexedLet
      let(:count_1) { Faker::Number.between(from: 1, to: 5) }
      let(:count_2) { Faker::Number.between(from: 1, to: 5) }
      let(:count_3) { Faker::Number.between(from: 1, to: 5) }
      # rubocop:enable RSpec/IndexedLet

      describe "journey type scopes" do
        before do
          create_list(:user_journey, count_1, :registration)
          create_list(:user_journey, count_2, :renewal)
          create_list(:user_journey, count_3, journey_type: "Foo")
        end

        it { expect(described_class.registrations.length).to eq count_1 }
        it { expect(described_class.renewals.length).to eq count_2 }
        it { expect(described_class.only_types(%w[NewRegistration]).length).to eq count_1 }
        it { expect(described_class.only_types(%w[RenewingRegistration]).length).to eq count_2 }
        it { expect(described_class.only_types(%w[NewRegistration RenewingRegistration]).length).to eq count_1 + count_2 }
      end

      describe "start route scopes" do
        before do
          create_list(:user_journey, count_1, :started_digital)
          create_list(:user_journey, count_2, :started_assisted_digital)
        end

        it { expect(described_class.started_digital.length).to eq count_1 }
        it { expect(described_class.started_assisted_digital.length).to eq count_2 }
      end

      describe "passed_start_cutoff_page" do
        describe "with location_form being a cutoff page" do
          let!(:journey_initial_page_only) { create(:user_journey, visited_pages: %w[start_form]) }
          let!(:journey_to_location_page) { create(:user_journey, visited_pages: %w[start_form location_form]) }
          let!(:journey_past_location_page) { create(:user_journey, visited_pages: %w[start_form location_form business_type_form]) }

          it { expect(described_class.passed_start_cutoff_page).not_to include(journey_initial_page_only) }
          it { expect(described_class.passed_start_cutoff_page).not_to include(journey_to_location_page) }
          it { expect(described_class.passed_start_cutoff_page).to include(journey_past_location_page) }
        end

        describe "with edit_exemptions_form being a cutoff page" do
          let!(:journey_initial_page_only) { create(:user_journey, visited_pages: %w[renewal_start_form]) }
          let!(:journey_to_edit_exemptions_page) { create(:user_journey, visited_pages: %w[renewal_start_form edit_exemptions_form]) }
          let!(:journey_past_edit_exemptions_page) { create(:user_journey, visited_pages: %w[renewal_start_form edit_exemptions_form deregistration_complete_no_change_form]) }

          it { expect(described_class.passed_start_cutoff_page).not_to include(journey_initial_page_only) }
          it { expect(described_class.passed_start_cutoff_page).not_to include(journey_to_edit_exemptions_page) }
          it { expect(described_class.passed_start_cutoff_page).to include(journey_past_edit_exemptions_page) }
        end

        describe "with front_office_edit_form being a cutoff page" do
          let!(:journey_initial_page_only) { create(:user_journey, visited_pages: %w[start_form]) }
          let!(:journey_to_front_office_edit_page) { create(:user_journey, visited_pages: %w[start_form front_office_edit_form]) }
          let!(:journey_past_front_office_edit_page) { create(:user_journey, visited_pages: %w[start_form front_office_edit_form contact_name_form]) }

          it { expect(described_class.passed_start_cutoff_page).not_to include(journey_initial_page_only) }
          it { expect(described_class.passed_start_cutoff_page).not_to include(journey_to_front_office_edit_page) }
          it { expect(described_class.passed_start_cutoff_page).to include(journey_past_front_office_edit_page) }
        end

        describe "with confirm_renewal_form being a cutoff page" do
          let!(:journey_initial_page_only) { create(:user_journey, visited_pages: %w[renewal_start_form]) }
          let!(:journey_to_confirm_renewal_page) { create(:user_journey, visited_pages: %w[renewal_start_form confirm_renewal_form]) }
          let!(:journey_past_confirm_renewal_page) { create(:user_journey, visited_pages: %w[renewal_start_form confirm_renewal_form declaration_form]) }

          it { expect(described_class.passed_start_cutoff_page).not_to include(journey_initial_page_only) }
          it { expect(described_class.passed_start_cutoff_page).not_to include(journey_to_confirm_renewal_page) }
          it { expect(described_class.passed_start_cutoff_page).to include(journey_past_confirm_renewal_page) }
        end
      end

      describe "completion scopes" do
        before do
          create_list(:user_journey, count_1, :completed_digital)
          create_list(:user_journey, count_2, :completed_assisted_digital)
          create_list(:user_journey, count_3, completed_at: nil)
        end

        it { expect(described_class.completed_digital.length).to eq count_1 }
        it { expect(described_class.completed_assisted_digital.length).to eq count_2 }
        it { expect(described_class.completed.length).to eq count_1 + count_2 }
        it { expect(described_class.incomplete.length).to eq count_3 }
      end

      describe ".date_range" do
        subject(:date_range_query_results) { described_class.date_range(start_date, end_date) }

        let(:start_date) { 10.days.ago.midnight }
        let(:end_date) { Date.today.midnight }

        context "with journeys started before the range" do
          let!(:journey_started_before_range) { Timecop.freeze(start_date - 2.days) { create(:user_journey, completed_at: start_date - 1.day) } }

          it "does not include journeys started before the range" do
            expect(date_range_query_results).not_to include(journey_started_before_range)
          end
        end

        context "with journeys starting at the range start" do
          let!(:journey_started_at_range_start) { Timecop.freeze(start_date) { create(:user_journey, completed_at: start_date + 1.day) } }

          it "includes journeys started at the range start" do
            expect(date_range_query_results).to include(journey_started_at_range_start)
          end
        end

        context "with journeys starting before the range end" do
          let!(:journey_started_before_range_end) { Timecop.freeze(end_date - 1.day) { create(:user_journey, completed_at: end_date) } }

          it "includes journeys started before the range end" do
            expect(date_range_query_results).to include(journey_started_before_range_end)
          end
        end

        context "with journeys starting after the range" do
          let!(:journey_started_after_range) { Timecop.freeze(end_date + 1.day) { create(:user_journey) } }

          it "does not include journeys started after the range" do
            expect(date_range_query_results).not_to include(journey_started_after_range)
          end
        end

        context "with journeys completed after the range" do
          let!(:journey_completed_after_range) { Timecop.freeze(start_date - 2.days) { create(:user_journey, completed_at: end_date + 1.day) } }

          it "does not include journeys completed after the range" do
            expect(date_range_query_results).not_to include(journey_completed_after_range)
          end
        end

        context "with ongoing journeys started in the range" do
          let!(:ongoing_journey_started_in_range) { Timecop.freeze(start_date + 1.day) { create(:user_journey, completed_at: nil) } }

          it "includes ongoing journeys started in the range" do
            expect(date_range_query_results).to include(ongoing_journey_started_in_range)
          end
        end

        context "with ongoing journeys started before the range" do
          let!(:ongoing_journey_started_before_range) { Timecop.freeze(start_date - 3.days) { create(:user_journey, completed_at: nil) } }

          it "does not include ongoing journeys started before the range" do
            expect(date_range_query_results).not_to include(ongoing_journey_started_before_range)
          end
        end

        context "with journeys started before and ended within the range" do
          let!(:journey_started_before_and_ended_within_range) { Timecop.freeze(start_date - 1.day) { create(:user_journey, completed_at: end_date) } }

          it "does not include journeys started before and ended within the range" do
            expect(date_range_query_results).not_to include(journey_started_before_and_ended_within_range)
          end
        end
      end

      describe "#complete_journey" do
        let(:transient_registration) { create(:new_registration) }
        let(:journey) { Timecop.freeze(1.hour.ago) { create(:user_journey, token: transient_registration.token) } }
        let(:completion_time) { Time.zone.now }

        before do
          allow(WasteExemptionsEngine.configuration).to receive(:host_is_back_office?).and_return(false)
          Timecop.freeze(completion_time) { journey.complete_journey(transient_registration) }
        end

        it "updates the completed_at attribute on completion" do
          expect(journey.completed_at).to be_within(1.second).of(completion_time)
        end

        it "sets the completed_route to 'DIGITAL' on completion" do
          expect(journey.completed_route).to eq "DIGITAL"
        end

        it "updates registration data with attributes from the transient registration on completion" do
          expected_attributes = transient_registration.attributes.slice("business_type", "type")
          expect(journey.registration_data).to include(expected_attributes)
        end
      end

      describe ".average_session_duration" do
        let(:completion_time) { Time.zone.now }

        before do
          @transient_registration_a = create(:new_registration)
          @transient_registration_b = create(:new_registration)
          @transient_registration_c = create(:renewing_registration)

          @journey_a = Timecop.freeze(6.hours.ago) { create(:user_journey, token: @transient_registration_a.token) }
          @journey_b = Timecop.freeze(4.hours.ago) { create(:user_journey, token: @transient_registration_b.token) }
          @journey_c = Timecop.freeze(1.hour.ago) { create(:user_journey, token: @transient_registration_c.token) }

          Timecop.freeze(completion_time) do
            @journey_a.complete_journey(@transient_registration_a)
            @journey_b.complete_journey(@transient_registration_b)
            # simulate a non-completion update:
            @journey_c.touch
          end
        end

        it "returns the average duration across all user journeys" do
          total_duration = [
            @journey_a.completed_at.to_time - @journey_a.created_at.to_time,
            @journey_b.completed_at.to_time - @journey_b.created_at.to_time,
            @journey_c.updated_at.to_time - @journey_c.created_at.to_time
          ].sum

          expect(described_class.average_duration(described_class.all)).to eq total_duration / 3
        end

        context "with completed registrations only" do
          it "returns the average duration across completed journeys only" do
            total_duration = [
              @journey_a.completed_at.to_time - @journey_a.created_at.to_time,
              @journey_b.completed_at.to_time - @journey_b.created_at.to_time
            ].sum

            expect(described_class.average_duration(described_class.completed)).to eq total_duration / 2
          end
        end

        context "with incomplete registrations only" do
          it "returns the average duration across incomplete journeys only" do
            duration = @journey_c.updated_at.to_time - @journey_c.created_at.to_time
            expect(described_class.average_duration(described_class.incomplete)).to eq duration
          end
        end
      end

      describe ".minimum_created_at" do
        before do
          @earliest_created_journey = create(:user_journey, created_at: 5.days.ago)
          @latest_created_journey = create(:user_journey, created_at: 1.day.ago)
        end

        it "returns the earliest created user journey" do
          expect(described_class.minimum_created_at).to be_within(1.second).of(@earliest_created_journey.created_at)
        end
      end
    end
  end
end

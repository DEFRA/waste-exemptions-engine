# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe SafeCopyRegistrationAttributesService do
    describe "#run" do

      shared_examples "returns the correct attributes" do

        subject(:run_service) { described_class.run(source:, target_class:, exclude:) }

        let(:target_class) { WasteExemptionsEngine::Registration }
        let(:copyable_attributes) { %w[location contact_phone] }
        let(:non_copyable_attributes) { %w[workflow_state temp_contact_postcode] }
        let(:exclusion_list) { %w[reference business_type] }
        let(:exclude) { nil }

        # ensure all available attributes are populated on the source
        before do
          source.class.columns.each do |attr|
            next unless source.send(attr.name).blank? && source.respond_to?("#{attr.name}=")

            source.send "#{attr.name}=", 0
          end
        end

        it { expect { run_service }.not_to raise_error }

        it "returns copyable attributes" do
          result = run_service
          copyable_attributes.each { |attr| expect(result[attr]).not_to be_nil }
        end

        it "does not return non-copyable attributes" do
          result = run_service
          non_copyable_attributes.each { |attr| expect(result[attr]).to be_nil }
        end

        context "with an exclusion list" do
          let(:exclude) { exclusion_list }

          it "does not return the excluded attibutes" do
            expect(run_service.keys).not_to include(exclusion_list)
          end
        end
      end

      context "when the source is a NewRegistration" do
        let(:source) { create(:new_registration, :complete) }

        it_behaves_like "returns the correct attributes"
      end

      context "when the source is a RenewingRegistration" do
        let(:source) { create(:renewing_registration, :with_all_addresses) }

        it_behaves_like "returns the correct attributes"
      end

      context "when the source is a BackOfficeEditRegistration" do
        let(:source) { create(:back_office_edit_registration) }

        it_behaves_like "returns the correct attributes"
      end

      context "when the source is a FrontOfficeEditRegistration" do
        let(:source) { create(:front_office_edit_registration) }

        it_behaves_like "returns the correct attributes"
      end
    end
  end
end

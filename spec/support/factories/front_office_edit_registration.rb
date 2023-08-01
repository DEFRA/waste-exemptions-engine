# frozen_string_literal: true

FactoryBot.define do
  factory :front_office_edit_registration, class: "WasteExemptionsEngine::FrontOfficeEditRegistration" do
    # Create a new registration when initializing so we can copy its data
    initialize_with do
      new(reference: create(:registration, :complete).reference)
    end

    trait :modified do
      after(:build) do |edit_registration|
        edit_registration["contact_first_name"] = "#{edit_registration['contact_first_name']}_X"
      end
    end

    trait :with_all_addresses do
      # dummy trait to allow use of transient_registration shared_examples
    end
  end
end

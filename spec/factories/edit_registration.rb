# frozen_string_literal: true

FactoryBot.define do
  factory :edit_registration, class: WasteExemptionsEngine::EditRegistration do
    # Create a new registration when initializing so we can copy its data
    initialize_with do
      new(reference: create(:registration, :complete).reference)
    end

    trait :with_manual_site_address do
      initialize_with do
        new(reference: create(:registration, :complete, :with_manual_site_address).reference)
      end
    end

    trait :modified do
      after(:build) do |edit_registration|
        registration = edit_registration.registration
        # Update string attributes
        (Helpers::ModelProperties::REGISTRATION - %i[is_a_farmer on_a_farm reference submitted_at]).each do |attribute|
          old_value = registration[attribute]
          new_value = "#{old_value}foo"

          edit_registration[attribute] = new_value
        end

        # Invert booleans
        %i[is_a_farmer on_a_farm].each do |attribute|
          old_value = registration[attribute]
          new_value = !old_value

          edit_registration[attribute] = new_value
        end
      end

      modified_addresses
      modified_people
    end

    trait :modified_addresses do
      after(:build) do |edit_registration|
        edit_registration.addresses.each do |address|
          address.attributes.each do |key, value|
            # Append 'foo' to the end of all string attributes
            address[key] = "#{value}foo" if value.is_a?(String)
          end

          address.save if address.persisted?
        end
      end
    end

    trait :with_all_addresses do
      addresses do
        [
          build(:transient_address, :operator_address, :manual),
          build(:transient_address, :contact_address, :manual),
          build(:transient_address, :site_address, :manual)
        ]
      end
    end

    trait :modified_people do
      after(:build) do |edit_registration|
        edit_registration.people.each do |person|
          person.attributes.each do |key, value|
            # Append 'foo' to the end of all string attributes
            person[key] = "#{value}foo" if value.is_a?(String)
          end
        end
      end
    end
  end
end

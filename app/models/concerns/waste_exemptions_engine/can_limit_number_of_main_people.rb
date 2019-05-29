# frozen_string_literal: true

module WasteExemptionsEngine
  module CanLimitNumberOfMainPeople
    extend ActiveSupport::Concern

    MAIN_PEOPLE_LIMITS = HashWithIndifferentAccess.new(
      TransientRegistration::BUSINESS_TYPES[:limited_company] => { minimum: 1, maximum: nil },
      TransientRegistration::BUSINESS_TYPES[:limited_liability_partnership] => { minimum: 1, maximum: nil },
      TransientRegistration::BUSINESS_TYPES[:local_authority] => { minimum: 1, maximum: nil },
      TransientRegistration::BUSINESS_TYPES[:charity] => { minimum: 1, maximum: nil },
      TransientRegistration::BUSINESS_TYPES[:partnership] => { minimum: 2, maximum: nil },
      TransientRegistration::BUSINESS_TYPES[:sole_trader] => { minimum: 1, maximum: 1 }
    )

    def enough_main_people?
      return false if number_of_existing_main_people < minimum_main_people

      true
    end

    def too_many_main_people?
      return false if maximum_main_people.nil?
      return true if number_of_existing_main_people > maximum_main_people

      false
    end

    def can_only_have_one_main_person?
      return false unless maximum_main_people

      maximum_main_people == 1
    end

    def maximum_main_people
      return unless business_type.present?

      limits = MAIN_PEOPLE_LIMITS.fetch(business_type, nil)
      return unless limits.present?

      limits[:maximum]
    end

    def minimum_main_people
      # Business type should always be set, but use 1 as the default, just in case
      return 1 unless business_type.present?

      limits = MAIN_PEOPLE_LIMITS.fetch(business_type, nil)
      return 1 unless limits.present?

      limits[:minimum]
    end

    def number_of_existing_main_people
      @transient_registration.transient_people.count
    end
  end
end

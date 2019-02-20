# frozen_string_literal: true

module WasteExemptionsEngine
  class MainPersonValidator < PersonValidator
    private

    def validate_number_of_people(record)
      return false unless enough_people?(record)

      not_too_many_people?(record)
    end

    def enough_people?(record)
      return true if record.enough_main_people?

      record.errors.add(:base, :not_enough_main_people, count: record.minimum_main_people)
    end

    def not_too_many_people?(record)
      return false unless record.too_many_main_people?

      record.errors.add(:base, :too_many_main_people, count: record.maximum_main_people)
    end
  end
end

# frozen_string_literal: true

module WasteExemptionsEngine
  class MainPersonFormValidator < PersonNameValidator
    include CanAddValidationErrors

    def validate(record)
      # Allow blank form submission if sufficient people already added
      return true if !fields_have_content?(record) && enough_main_people?(record)

      super(record)
    end

    private

    def fields_have_content?(record)
      record.first_name.present? || record.last_name.present?
    end

    def enough_main_people?(record)
      record.business_type != "partnership" || record.transient_people.length > 1
    end
  end
end

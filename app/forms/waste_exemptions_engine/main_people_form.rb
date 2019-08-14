# frozen_string_literal: true

module WasteExemptionsEngine
  class MainPeopleForm < PersonForm
    include CanLimitNumberOfMainPeople

    attr_accessor :business_type

    # After callbacks are called in reverse order, so the last one in the list is called first
    set_callback :initialize, :after, :prefill_form, if: :can_prefill_form?
    set_callback :initialize, :after, :set_business_type

    def person_type
      TransientPerson.person_types[:partner]
    end

    validates_with MainPersonValidator

    private

    def set_business_type
      # We only use this for the correct microcopy
      self.business_type = @transient_registration.business_type
    end

    def can_prefill_form?
      # If there's only one main person, we can pre-fill the fields so users can easily edit them
      can_only_have_one_main_person? && @transient_registration.transient_people.present?
    end

    def prefill_form
      self.first_name = @transient_registration.transient_people.first.first_name
      self.last_name = @transient_registration.transient_people.first.last_name
    end

  end
end

# frozen_string_literal: true

module WasteExemptionsEngine
  class MainPeopleForm < PersonForm
    include CanLimitNumberOfMainPeople
    include CanNavigateFlexibly

    attr_accessor :business_type

    def initialize(transient_registration)
      super
      # We only use this for the correct microcopy
      self.business_type = @transient_registration.business_type

      # If there's only one main person, we can pre-fill the fields so users can easily edit them
      prefill_form if can_only_have_one_main_person? && @transient_registration.transient_people.present?
    end

    def person_type
      TransientPerson.person_types[:partner]
    end

    validates_with MainPersonValidator

    private

    def prefill_form
      self.first_name = @transient_registration.transient_people.first.first_name
      self.last_name = @transient_registration.transient_people.first.last_name
    end

  end
end

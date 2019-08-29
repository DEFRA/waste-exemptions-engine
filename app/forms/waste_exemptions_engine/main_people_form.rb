# frozen_string_literal: true

module WasteExemptionsEngine
  class MainPeopleForm < BaseForm
    attr_accessor :business_type
    attr_accessor :first_name, :last_name

    delegate :transient_people, to: :transient_registration

    validates :first_name, :last_name, "waste_exemptions_engine/person_name": true

    def initialize(transient_registration)
      super
      # We only use this for the correct microcopy
      self.business_type = @transient_registration.business_type

      # If there's only one main person, we can pre-fill the fields so users can easily edit them
      prefill_form if @transient_registration.transient_people.count == 1
    end

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.first_name = params[:first_name]
      self.last_name = params[:last_name]

      set_up_new_person if valid?

      super({})
    end

    private

    def prefill_form
      self.first_name = @transient_registration.transient_people.first.first_name
      self.last_name = @transient_registration.transient_people.first.last_name
    end

    def set_up_new_person
      @transient_registration.transient_people.build(
        first_name: first_name,
        last_name: last_name
      )
    end
  end
end

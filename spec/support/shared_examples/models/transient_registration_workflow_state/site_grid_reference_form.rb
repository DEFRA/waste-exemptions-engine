# frozen_string_literal: true

RSpec.shared_examples "site_grid_reference_form" do
  context "when a TransientRegistration's state is :site_grid_reference_form" do
    let(:current_state) { :site_grid_reference_form }
    let(:next_states) { %i[check_site_address_form check_your_answers_form] }

    it "can transition to check_site_address_form or check_your_answers_form" do
      permitted_states = Helpers::WorkflowStates.permitted_states(transient_registration)
      expect(permitted_states).to match_array(next_states)
    end

    it "changes to check_site_address_form after the 'next' event if skip_to_manual_address? is true" do
      allow(transient_registration).to receive(:skip_to_manual_address?).and_return(true)
      expect(transient_registration).to transition_from(current_state).to(:check_site_address_form).on_event(:next)
    end

    it "changes to check_your_answers_form after the 'next' event if skip_to_manual_address? is false" do
      allow(transient_registration).to receive(:skip_to_manual_address?).and_return(false)
      expect(transient_registration).to transition_from(current_state).to(:check_your_answers_form).on_event(:next)
    end
  end
end

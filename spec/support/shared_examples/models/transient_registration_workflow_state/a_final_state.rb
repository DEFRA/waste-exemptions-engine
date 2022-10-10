# frozen_string_literal: true

RSpec.shared_examples "a final state" do |current_state:, factory:|
  context "when a subject's state is #{current_state}" do
    subject { create(factory, workflow_state: current_state) }

    it "is unable to transition when the 'next' event is issued" do
      expect { subject.next }.to raise_error(AASM::InvalidTransition)
    end
  end
end

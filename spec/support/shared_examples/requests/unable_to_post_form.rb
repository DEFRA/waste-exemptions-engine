# frozen_string_literal: true

require "waste_exemptions_engine/exceptions/unsubmittable_form"

RSpec.shared_examples "unable to POST form" do |form_factory, path|
  let(:form) { build(form_factory) }
  let(:post_request_path) { "/waste_exemptions_engine#{path}" }
  let(:request_body) { { form_factory => { token: form.token } } }

  describe "POST #{form_factory} back" do
    it "raises an UnsubmittableForm error" do
      expect { post post_request_path, request_body }.to raise_error do |error|
        allowed_errors = [
          WasteExemptionsEngine::UnsubmittableForm,
          ActionController::RoutingError,
          ActionView::MissingTemplate,
          AASM::InvalidTransition
        ]
        expect(error.class).to be_in(allowed_errors)
      end
    end
  end
end

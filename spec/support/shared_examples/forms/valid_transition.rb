# frozen_string_literal: true

RSpec.shared_examples "a valid transition" do |request_path, redirects_to|
  let(:form) { build(form_name) }

  it "redirects to valid form page" do
    get send(request_path, token: form.token)

    expect(response).to redirect_to send(redirects_to, token: form.token)
  end

  it "sets temp_check_your_answers_flow variable to true" do
    get send(request_path, token: form.token)

    expect(form.transient_registration.reload.temp_check_your_answers_flow).to be_truthy
  end

  it "adds the form into the workflow history" do
    get send(request_path, token: form.token)

    expect(form.transient_registration.reload.workflow_history.last).to eq(form_name)
  end
end

# frozen_string_literal: true

RSpec.shared_examples "an optional email form", vcr: true do |form_factory, email_attribute|
  subject(:form) { build(form_factory) }

  describe "validations" do
    subject(:validators) { form._validators }

    describe "email attribute validation" do
      it "validates the #{email_attribute} using the OptionalEmailFormValidator class" do
        expect(validators[email_attribute].first.class).to eq(WasteExemptionsEngine::OptionalEmailFormValidator)
      end
    end
  end

  it_behaves_like "a validated form", form_factory do
    let(:valid_params) do
      { "#{email_attribute}": "test@example.com", confirmed_email: "test@example.com" }
    end
    let(:invalid_params) do
      [
        { "#{email_attribute}": "test@example.com", confirmed_email: "different@example.com" },
        { "#{email_attribute}": "", confirmed_email: "test@example.com" },
        { "#{email_attribute}": "test@example.com", confirmed_email: "" },
        { "#{email_attribute}": "", confirmed_email: "" }
      ]
    end
  end

  describe "#submit" do
    let(:params) do
      {
        "#{email_attribute}": email_address,
        confirmed_email: email_address,
        no_email_address: defined?(no_email_address) ? no_email_address : nil
      }
    end
    let(:email_address) { Faker::Internet.email }
    let(:is_back_office) { false }

    before { allow(WasteExemptionsEngine.configuration).to receive(:host_is_back_office?).and_return(is_back_office) }

    shared_examples "should submit" do
      it "submits the form successfully" do
        expect(form.submit(ActionController::Parameters.new(params))).to be(true)
      end
    end

    shared_examples "should not submit" do
      it "does not submit the form successfully" do
        expect(form.submit(ActionController::Parameters.new(params))).to be(false)
      end
    end

    context "when the form is valid" do
      context "when running in the front office" do
        let(:is_back_office) { false }

        context "with an email address" do
          let(:email_address) { Faker::Internet.email }

          it_behaves_like "should submit"

          it "updates the transient registration with the contact email address" do
            expect { form.submit(ActionController::Parameters.new(params).permit!) }
              .to change { form.transient_registration.send(email_attribute) }
              .from(nil).to(email_address)
          end
        end
      end

      context "when running in the back office" do
        let(:is_back_office) { true }

        context "with an email address" do
          let(:email_address) { Faker::Internet.email }

          it_behaves_like "should submit"

          it "populates the email" do
            expect { form.submit(ActionController::Parameters.new(params)) }
              .to change { form.transient_registration.send(email_attribute) }
              .from(nil).to(email_address)
          end
        end

        context "with a blank email address" do
          let(:email_address) { "" }
          let(:no_email_address) { "1" }

          it_behaves_like "should submit"

          it "does not populate the email" do
            expect { form.submit(ActionController::Parameters.new(params)) }
              .not_to change { form.transient_registration.read_attribute(email_attribute) }.from(nil)
          end
        end
      end
    end

    context "when the form is not valid" do
      context "when running in the front office" do
        let(:is_back_office) { false }

        context "with no parameters" do
          let(:params) { {} }

          it_behaves_like "should not submit"
        end
      end

      context "when running in the back office" do
        let(:is_back_office) { true }

        context "without an email address and with the no-email-address option not selected" do
          let(:email_address) { nil }
          let(:no_email_address) { "0" }

          it_behaves_like "should not submit"
        end

        context "with an email address and with the no-email-address option selected" do
          let(:email_address) { Faker::Internet.email }
          let(:no_email_address) { "1" }

          it_behaves_like "should not submit"
        end
      end
    end
  end
end

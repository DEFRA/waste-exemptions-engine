# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ConfirmationMailer, type: :mailer do
    before(:all) do
      @service_email = "test@wex.gov.uk"
      WasteExemptionsEngine.configuration.email_service_email = @service_email

      @registration = create(:registration, :confirmable)
      @recipient = "test@example.com"
      @mail = ConfirmationMailer.send_confirmation_email(@registration, @recipient)
    end

    describe "#send_confirmation_email" do
      it "uses the correct 'to' address" do
        expect(@mail.to).to eq([@recipient])
      end

      it "uses the correct 'from' address" do
        expect(@mail.from).to eq([@service_email])
      end

      it "uses the correct subject" do
        subject = "Waste exemptions registration #{@registration.reference} completed"
        expect(@mail.subject).to eq(subject)
      end

      it "includes the correct template in the body" do
        expect(@mail.body.encoded).to include("This is not a permit")
      end
    end

    context "attachments" do
      it "has 3 attachments (pdf and logo)" do
        expect(@mail.attachments.length).to eq(3)
      end

      context "confirmation pdf" do
        let(:confirmation_pdf) { @mail.attachments[0] }

        it "is a pdf file" do
          expect(confirmation_pdf.content_type).to start_with("application/pdf;")
        end

        it "has the right reference as its filename" do
          expect(confirmation_pdf.filename).to eq("#{@registration.reference}.pdf")
        end

        context "errors when generated" do
          before do
            allow(GeneratePdfService).to receive(:new).and_raise(StandardError)
          end
          # Because we have @mail created before all tests run this test would
          # fail because the mail will have been generated prior to this before
          # block doing its thing. If you switch the top level before block to
          # :each, you can get rid of this let but the tests run very, very
          # slowly!
          let(:mail) { ConfirmationMailer.send_confirmation_email(@registration, @recipient) }

          it "does not block the email from completing" do
            expect(mail.to).to eq([@recipient])
            expect(mail.from).to eq([@service_email])
            expect(mail.attachments.length).to eq(2)
          end
        end
      end

      context "privacy policy pdf" do
        let(:privacy_pdf) { @mail.attachments[1] }

        it "is a pdf file" do
          expect(privacy_pdf.content_type).to start_with("application/pdf;")
        end

        it "has the right filename" do
          expect(privacy_pdf.filename).to eq("privacy_policy.pdf")
        end
      end

      context "GOV.UK logo" do
        let(:logo_png) { @mail.attachments[2] }

        it "is a png file" do
          expect(logo_png.content_type).to start_with("image/png")
        end

        it "has the right filename" do
          expect(logo_png.filename).to eq("govuk_logotype_email.png")
        end
      end
    end
  end
end

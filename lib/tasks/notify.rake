# frozen_string_literal: true

namespace :notify do
  namespace :test do
    desc "Send a test confirmation email to the newest registration in the DB"
    task confirmation: :environment do
      registration = WasteExemptionsEngine::Registration.last
      recipient = registration.contact_email

      WasteExemptionsEngine::ConfirmationEmailService.run(registration: registration, recipient: recipient)
    end
  end
end

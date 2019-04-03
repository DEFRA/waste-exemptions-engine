# frozen_string_literal: true

require "waste_exemptions_engine/privacy_policy_pdf_generator"

namespace :pdfs do
  desc "Generate privacy policy as pdf"
  task privacy: :environment do
    generated_file = WasteExemptionsEngine::PrivacyPolicyPdfGenerator.generate
    puts "PDF generated! #{generated_file}"
  end
end

# frozen_string_literal: true

require "wicked_pdf"
require "ostruct"

if WasteExemptionsEngine.configuration.use_xvfb_for_wickedpdf
  WickedPdf.configure do |config|
    config.exe_path = WasteExemptionsEngine::Engine.root.join("script", "wkhtmltopdf.sh").to_s
  end
end

# frozen_string_literal: true

require "wicked_pdf"

if WasteExemptionsEngine.configuration.use_xvfb_for_wickedpdf == "true"
  WickedPdf.config = {
    exe_path: WasteExemptionsEngine::Engine.root.join("script", "wkhtmltopdf.sh").to_s
  }
end

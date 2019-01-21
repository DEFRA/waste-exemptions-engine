# frozen_string_literal: true

require "wicked_pdf"

if ENV["USE_XVFB_FOR_WICKEDPDF"] == "true"
  WickedPdf.config = {
    exe_path: WasteExemptionsEngine::Engine.root.join("script", "wkhtmltopdf.sh").to_s
  }
end

# frozen_string_literal: true

module WasteExemptionsEngine
  class PrivacyPolicyPdfGenerator
    def self.generate
      root_path = File.join(__dir__, "..", "..")

      privacy_html_path = File.absolute_path(
        File.join(root_path, "app/views/waste_exemptions_engine/pdfs/privacy.html")
      )
      pdf_generator = GeneratePdfService.new(File.read(privacy_html_path))

      # As a gem, the /tmp folder is not typically created in the engine project.
      # So if we attempt to write to it when it doesn't exist we'll get an error.
      # N.B. It will be ignored because its already covered by .gitignore file
      output_path = File.join(root_path, "tmp")
      FileUtils.mkdir_p output_path

      # The `b` option is important. `w` means write and `b` means binary file
      # mode. The pdf attribute is a file not a string so without this mode we get
      # encoding errors.
      privacy_pdf_path = File.absolute_path(File.join(output_path, "privacy_policy.pdf"))
      File.open(privacy_pdf_path, "wb") { |file| file << pdf_generator.pdf }

      privacy_pdf_path
    end
  end
end

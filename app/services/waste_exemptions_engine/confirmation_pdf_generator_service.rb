# frozen_string_literal: true

module WasteExemptionsEngine
  class ConfirmationPdfGeneratorService < BaseService
    def run(registration:)
      @registration = registration

      pdf_generator.pdf
    end

    private

    def pdf_generator
      GeneratePdfService.new(template)
    end

    def template
      ApplicationController.new.render_to_string(
        pdf: "certificate",
        template: "waste_exemptions_engine/pdfs/certificate",
        encoding: "UTF-8",
        locals: locals
      )
    end

    def locals
      {
        presenter: presenter
      }
    end

    def presenter
      CertificatePresenter.new(@registration)
    end
  end
end

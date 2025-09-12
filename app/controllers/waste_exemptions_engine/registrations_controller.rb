# frozen_string_literal: true

module WasteExemptionsEngine
  class RegistrationsController < ::WasteExemptionsEngine::ApplicationController
    helper PluralsHelper

    def complete
      find_registration(params[:registration_reference])

      if @registration.nil? || !valid_email?(params[:email])
        redirect_to page_path("invalid")
        return
      end

      @registration_complete_form = WasteExemptionsEngine::RegistrationCompleteForm.new(@registration)
      render("waste_exemptions_engine/registration_complete_forms/new")
    end

    def find_registration(reference)
      @registration = WasteExemptionsEngine::Registration.find_by(reference: reference)
    end

    def valid_email?(email)
      [@registration.contact_email,
       @registration.applicant_email].compact.map(&:downcase).include?(email.to_s.strip.downcase)
    end
  end
end

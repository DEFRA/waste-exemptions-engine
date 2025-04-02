# frozen_string_literal: true

class SendRegistrationEditEmailJob < ApplicationJob
  def perform(reference:, email:)
    @email = email
    ActiveRecord::Base.transaction do
      @registration = WasteExemptionsEngine::RegistrationEmailMatchService.run(reference: reference, email: email)
      return if @registration.blank?

      # Generate once only
      magic_link_token = generate_magic_link_token

      if @registration.contact_email.present?
        WasteExemptionsEngine::RegistrationEditLinkEmailService.run(
          registration: @registration, magic_link_token:, recipient: @registration.contact_email
        )
      end

      if @registration.applicant_email.present? && @registration.applicant_email != @registration.contact_email
        WasteExemptionsEngine::RegistrationEditLinkEmailService.run(
          registration: @registration, magic_link_token:, recipient: @registration.applicant_email
        )
      end

      set_edit_link_requested_by
    end
  end

  private

  def generate_magic_link_token
    @registration.regenerate_and_timestamp_edit_token
    @registration.edit_token
  end

  def set_edit_link_requested_by
    @registration.update(edit_link_requested_by: @email)
  end
end

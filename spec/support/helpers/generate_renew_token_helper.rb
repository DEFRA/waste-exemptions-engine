# frozen_string_literal: true

require "jwt"

module GenerateRenewTokenHelper
  def generate_valid_renew_token(registration)
    payload = { data: { registration_id: registration.id }, exp: Time.now.to_i + 100 }

    generate_test_renew_token(registration, payload)
  end

  def generate_expired_renew_token(registration)
    payload = { data: { registration_id: registration.id }, exp: Time.now.to_i - 1000 }

    generate_test_renew_token(registration, payload)
  end

  def generate_invalid_payload_renew_token(registration)
    payload = {}

    generate_test_renew_token(registration, payload)
  end

  def generate_test_renew_token(registration, payload)
    registration.renew_token = JWT.encode(payload, Rails.application.secrets.secret_key_base, "HS384")

    registration.save

    registration.renew_token
  end

  def generate_renew_token_without_updating_registration(registration)
    payload = { data: { registration_id: registration.id }, exp: Time.now.to_i - 100 }

    JWT.encode(payload, Rails.application.secrets.secret_key_base, "HS384")
  end
end

RSpec.configure do |config|
  config.include GenerateRenewTokenHelper
end

# frozen_string_literal: true

Rails.application.routes.draw do
  mount WasteExemptionsEngine::Engine => "/waste_exemptions_engine"
end

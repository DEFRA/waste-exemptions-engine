# frozen_string_literal: true

module WasteExemptionsEngine
  module DataLayerHelper

    def data_layer(transient_registration)
      output = []

      data_layer_hash(transient_registration).each do |key, value|
        output << "'#{key}': '#{value}'"
      end

      output.join(",")
    end

    private

    def data_layer_hash(transient_registration)
      {
        journey: data_layer_value_for_journey(transient_registration)
      }
    end

    def data_layer_value_for_journey(transient_registration)
      case transient_registration.class.name
      when "WasteExemptionsEngine::EditRegistration"
        :edit
      when "WasteExemptionsEngine::NewRegistration"
        :new
      when "WasteExemptionsEngine::RenewingRegistration"
        :renew
      end
    end
  end
end

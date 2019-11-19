# frozen_string_literal: true

require "rest-client"

module WasteExemptionsEngine
  class AddressFinderService
    def initialize(postcode)
      # Strip out non-alphanumeric characters
      @postcode = postcode.gsub(/[^a-z0-9]/i, "")
      @url = WasteExemptionsEngine.configuration.address_host +
             "/address-service/v1/addresses/postcode?postcode=#{@postcode}&client-id=0&key=client1"
    end

    def search_by_postcode
      Rails.logger.debug "Sending request to Address lookup service"

      begin
        response = RestClient::Request.execute(method: :get,
                                               url: @url)
        JSON.parse(response)["results"]
      rescue JSON::ParserError => e
        handle_error(e)
        :error
      rescue RestClient::BadRequest => e
        handle_error(e)
        :not_found
      rescue StandardError => e
        handle_error(e)
        :error
      end
    end

    private

    def handle_error(error)
      Airbrake.notify(error, url: @url) if defined?(Airbrake)
      Rails.logger.error "Address Finder error: #{error}"
    end
  end
end

# frozen_string_literal: true

DefraRubyMap.configure do |config|
  config.os_maps_api_key = ENV.fetch("OS_MAPS_API_KEY", nil)
end

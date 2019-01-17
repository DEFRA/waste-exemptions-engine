# frozen_string_literal: true

module WasteExemptionsEngine
  module MailerHelper

    # This ensures that an images we need to display in an email are shown by
    # adding them as attachments rather than exposing them as links to the
    # service. We have found this a more reliable method and is used in WCR, WEX
    # and FRAE
    def email_image_tag(image, **options)
      path = "/app/assets/images/waste_exemptions_engine/#{image}"

      full_path = Rails.root.join(path)

      full_path = "#{Gem.loaded_specs['waste_exemptions_engine'].full_gem_path}#{path}" unless File.exist?(full_path)

      attachments[image] = {
        data: File.read(full_path),
        mime_type: "image/png"
      }

      image_tag(attachments[image].url, **options)
    end

  end
end

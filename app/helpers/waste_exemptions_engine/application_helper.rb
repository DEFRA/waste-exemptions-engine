# frozen_string_literal: true

module WasteExemptionsEngine
  module ApplicationHelper
    def title
      title_elements = [title_text, "Register your waste exemptions", "GOV.UK"]
      # Remove empty elements, for example if no specific title is set
      title_elements.delete_if(&:empty?)
      title_elements.join(" - ")
    end

    def format_names(first_name, last_name)
      "#{first_name} #{last_name}"
    end

    def current_git_commit
      @current_git_commit ||= begin
        sha =
          if Rails.env.development?
            `git rev-parse HEAD`
          else
            heroku_file = Rails.root.join ".source_version"
            capistrano_file = Rails.root.join "REVISION"

            if File.exist? capistrano_file
              File.open(capistrano_file, &:gets)
            elsif File.exist? heroku_file
              File.open(heroku_file, &:gets)
            end
          end

        sha[0...7] if sha.present?
      end
    end

    def displayable_address(address)
      return [] unless address.present?

      # Get all the possible address lines, then remove the blank ones
      [address.organisation,
       address.premises,
       address.street_address,
       address.locality,
       address.city,
       address.postcode].reject(&:blank?)
    end

    # WickedPdf does come with helpers that you can use
    def wicked_pdf_image_tag(img, options = {})
      image_tag "file:///#{WasteExemptionsEngine::Engine.root.join('app', 'assets', 'images', img)}", options
    end

    private

    def title_text
      # Check if the title is set in the view (we do this for High Voltage pages)
      return content_for :title if content_for?(:title)

      # Otherwise, look up translation key based on controller path, action name and .title
      # Solution from https://coderwall.com/p/a1pj7w/rails-page-titles-with-the-right-amount-of-magic
      title = t("#{controller_path.tr('/', '.')}.#{action_name}.title", default: "")
      return title if title.present?

      # Default to title for "new" action if the current action doesn't return anything
      t("#{controller_path.tr('/', '.')}.new.title", default: "")
    end
  end
end

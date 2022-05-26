# frozen_string_literal: true

module WasteExemptionsEngine
  class BaseService
    def self.run(options = nil)
      if options && !options.is_a?(Hash)
        new.run(options)
      elsif options
        new.run(**options)
      else
        new.run
      end
    end

    private

    # :nocov:
    def log(message)
      puts message unless Rails.env.test?
    end
    # :nocov:
  end
end

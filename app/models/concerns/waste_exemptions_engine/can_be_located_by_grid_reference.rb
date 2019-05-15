# frozen_string_literal: true

module WasteExemptionsEngine
  module CanBeLocatedByGridReference
    extend ActiveSupport::Concern

    included do
      def located_by_grid_reference?
        site? && auto?
      end
    end
  end
end

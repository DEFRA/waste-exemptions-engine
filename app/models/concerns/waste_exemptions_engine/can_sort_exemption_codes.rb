# frozen_string_literal: true

module WasteExemptionsEngine
  module CanSortExemptionCodes
    extend ActiveSupport::Concern

    included do

      def sorted_exemption_codes
        sort_exemption_codes(exemptions.map(&:code))
      end

      private

      def sort_exemption_codes(codes)
        codes.sort_by do |code|
          category = code[0]
          number = code[1..].to_i

          case category
          when "U" then [0, number]
          when "T" then [1, number]
          when "D" then [2, number]
          when "S" then [3, number]
          else [4, number] # In case there's an unexpected category
          end
        end
      end
    end
  end
end

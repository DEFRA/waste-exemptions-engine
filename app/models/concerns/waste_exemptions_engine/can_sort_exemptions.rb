# frozen_string_literal: true

module WasteExemptionsEngine
  module CanSortExemptions
    extend ActiveSupport::Concern

    included do

      def sorted_exemption_codes(exemptions)
        sort_exemption_codes(exemptions&.map(&:code) || [])
      end

      def sorted_exemptions(exemptions)
        exemptions.sort_by do |exemption|
          sort_order(exemption.code[0], exemption.code[1..].to_i)
        end
      end

      private

      def sort_exemption_codes(codes)
        codes.sort_by do |code|
          sort_order(code[0], code[1..].to_i)
        end
      end

      def sort_order(category, number)
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

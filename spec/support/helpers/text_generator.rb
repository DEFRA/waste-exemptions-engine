# frozen_string_literal: true

module Helpers
  module TextGenerator
    def self.random_string(length)
      random_string_from_sequence([("a".."z"), ("A".."Z")].map(&:to_a).flatten, length)
    end

    def self.random_number_string(length)
      random_string_from_sequence(("0".."9").to_a, length)
    end

    def self.random_string_from_sequence(sequence, length)
      (0...length).map { sequence[rand(sequence.length)] }.join
    end
  end
end

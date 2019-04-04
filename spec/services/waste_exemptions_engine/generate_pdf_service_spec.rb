# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe GeneratePdfService do
    subject { described_class.new(test_content) }

    describe "when initialized" do
      context "with a string" do
        let(:test_content) { "<h1>Hello There!</h1>" }

        it "returns a generated pdf when its `pdf` attribute is read" do
          # There doesn't appear to be any special way to confirm its a PDF other
          # than checking the string returned starts with this
          expect(subject.pdf).to start_with("%PDF-")
        end
      end

      context "with 'nil'" do
        let(:test_content) { nil }

        it "returns 'nil` when its `pdf` attribute is read'" do
          expect(subject.pdf).to be_nil
        end
      end
    end
  end
end

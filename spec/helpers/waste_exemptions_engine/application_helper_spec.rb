# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ApplicationHelper, type: :helper do
    describe "#format_names" do
      it "concatenates first and last name into a full name" do
        expect(helper.format_names("Fiona", "Laurel")).to eq("Fiona Laurel")
      end
    end

    describe "title" do
      context "when a specific title is provided" do
        before do
          allow(helper).to receive(:content_for?).and_return(true)
          allow(helper).to receive(:content_for).with(:title).and_return("Foo")
          allow(helper).to receive(:content_for).with(:error_title).and_return("")
        end

        it "returns the correct full title" do
          expect(helper.title).to eq("Foo - Register your waste exemptions - GOV.UK")
        end

        context "when the page is displaying an error message" do
          before do
            allow(helper).to receive(:content_for).with(:error_title).and_return("Error")
          end

          it "returns the correct full title" do
            expect(helper.title).to eq("Error - Foo - Register your waste exemptions - GOV.UK")
          end
        end
      end

        context "when no specific title is provided" do
          it "returns the correct full title" do
            expect(helper.title).to eq("Register your waste exemptions - GOV.UK")
          end
        end
    end 
  end
end

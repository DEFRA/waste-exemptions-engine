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

    describe "#html_id_for" do

      context "with spaces in the text" do
        let(:prefix) { Faker::Lorem.word }
        let(:text) { Faker::Lorem.words(number: 3).join(" ") }

        it "replaces the spaces with underscores" do
          expect(helper.html_id_for(prefix, text)).to eq "#{prefix}_#{text.gsub(' ', '_')}".downcase
        end
      end

      context "with both upper and lower case values in the text" do
        let(:prefix) { Faker::Lorem.word.upcase }
        let(:text) { "Alpha beTa deltaGamma" }

        it "produces lower case text only" do
          expect(helper.html_id_for(prefix, text)).to eq "#{prefix.downcase}_alpha_beta_deltagamma"
        end
      end
    end

    describe "expiry date" do
      let(:registration) { create(:registration, :complete) }

      it "returns the correct expiry date with day, month and year" do
        expect(helper.registration_expires_day_month_year(registration)).to eq("#{3.years.from_now.strftime('%-d')} #{3.years.from_now.strftime('%B')} #{3.years.from_now.year}")
      end
    end
  end
end

# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe PagesController do
    it "includes HighVoltage::StaticPage" do
      included_modules = described_class.ancestors.select { |ancestor| ancestor.instance_of?(Module) }

      expect(included_modules)
        .to include(HighVoltage::StaticPage)
    end

    describe "#user_for_paper_trail" do
      before do
        allow(WasteExemptionsEngine.configuration).to receive(:use_current_user_for_whodunnit).and_return(true)
      end

      context "when current_user is present" do
        let(:user) { double("User", id: 123) } # rubocop:disable RSpec/VerifiedDoubles

        before do
          allow(controller).to receive(:current_user).and_return(user)
        end

        it "returns the user id" do
          expect(controller.send(:user_for_paper_trail)).to eq(123)
        end
      end

      context "when current_user is nil" do
        before do
          allow(controller).to receive(:current_user).and_return(nil)
        end

        it "returns 'public user'" do
          expect(controller.send(:user_for_paper_trail)).to eq("public user")
        end

        it "doesn't raise NoMethodError" do
          expect { controller.send(:user_for_paper_trail) }.not_to raise_error
        end
      end

      context "when use_current_user_for_whodunnit is false" do
        before do
          allow(WasteExemptionsEngine.configuration).to receive(:use_current_user_for_whodunnit).and_return(false)
        end

        it "returns 'public user'" do
          expect(controller.send(:user_for_paper_trail)).to eq("public user")
        end
      end
    end
  end
end

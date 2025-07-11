# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Suppress parameter logging" do
    non_suppressed_route = WasteExemptionsEngine::Engine.routes.url_helpers.new_site_postcode_form_path(token: "foo")
    engine_route = WasteExemptionsEngine::Engine.routes.url_helpers.process_govpay_webhook_path
    engine_route_without_prefix = "/govpay_payment_update"
    engine_route_with_other_prefix = "/fo/govpay_payment_update"
    engine_route_with_suffix = "#{engine_route}_foo"
    engine_route_with_subpath = "#{engine_route}/foo"

    let(:webhook_body) { file_fixture("govpay/webhook_payment_update_body.json").read }
    let(:headers) { { "Pay-Signature" => "a_signature" } }

    before do
      allow(Rails.logger).to receive(:info).and_call_original
    end

    around do |example|
      # Add temporary routes to test non-engine paths
      Rails.application.routes.draw do
        # draw replaces existing routes, so we need to re-add them:
        instance_eval(File.read(Rails.root.join("config/routes.rb")))

        post engine_route_without_prefix, to: "waste_exemptions_engine/govpay_webhook_callbacks#process_webhook"
        post engine_route_with_other_prefix, to: "waste_exemptions_engine/govpay_webhook_callbacks#process_webhook"
        post engine_route_with_suffix, to: "waste_exemptions_engine/govpay_webhook_callbacks#process_webhook"
        post engine_route_with_subpath, to: "waste_exemptions_engine/govpay_webhook_callbacks#process_webhook"
      end

      example.run

      # Restore original routes from routes.rb
      Rails.application.routes_reloader.execute_if_updated
    end

    context "when calling routes WITHOUT suppressed logging" do

      shared_examples "non-suppressed route" do |route|
        it "writes parameters to the log" do
          post route, headers: headers, params: {foo: :bar}.to_json

          expect(Rails.logger).to have_received(:info).with(/Parameters:.*foo.*bar/)
        end
      end

      context "with a route not specified for suppression" do
        it_behaves_like "non-suppressed route", non_suppressed_route
      end

      context "with the engine route with a suffix" do
        it_behaves_like "non-suppressed route", engine_route_with_suffix
      end

      context "with the engine route with a subpath" do
        it_behaves_like "non-suppressed route", engine_route_with_subpath
      end
    end

    context "when calling routes WITH suppressed logging" do

      shared_examples "suppressed_route" do |route|
        it "does not write parameters to the log" do
          post route, headers: headers, params: webhook_body

          expect(Rails.logger).not_to have_received(:info).with(/Parameters:/)
        end
      end

      context "with the engine route" do
        it_behaves_like "suppressed_route", engine_route
      end

      context "without a prefix" do
        it_behaves_like "suppressed_route", engine_route_without_prefix
      end

      context "with a prefix" do
        it_behaves_like "suppressed_route", engine_route_with_other_prefix
      end
    end
  end
end

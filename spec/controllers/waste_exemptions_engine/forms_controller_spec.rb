# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe FormsController, type: :controller do
    routes { WasteExemptionsEngine::Engine.routes }

    controller do
      def new
        super(LocationForm, "location_form")
      end
    end

    context "when a GET request is made" do
      context "and the token is not recognised" do
        it "returns a 302 response" do
          get :new, token: "foobar12345"
          expect(response).to have_http_status 302
        end

        it "redirects to the start page" do
          get :new, token: "foobar12345"
          expect(response).to redirect_to("/")
        end
      end
    end
  end
end

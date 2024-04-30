# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe Bucket do
    describe "public interface" do
      subject(:bucket) { build(:bucket) }

      Helpers::ModelProperties::BUCKET.each do |property|
        it "responds to property" do
          expect(bucket).to respond_to(property)
        end
      end
    end
  end
end

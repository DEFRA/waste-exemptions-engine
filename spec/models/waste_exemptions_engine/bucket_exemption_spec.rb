# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe BucketExemption do
    describe "public interface" do
      subject(:bucket_exemption) { build(:bucket_exemption) }

      Helpers::ModelProperties::BUCKET_EXEMPTION.each do |property|
        it "responds to property" do
          expect(bucket_exemption).to respond_to(property)
        end
      end
    end
  end
end

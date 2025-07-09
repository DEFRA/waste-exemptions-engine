# frozen_string_literal: true

FactoryBot.define do
  factory :ea_public_face_area, class: "WasteExemptionsEngine::EaPublicFaceArea" do
    transient do
      id_and_code { "1" }
    end

    after(:build) do |ea_area, evaluator|
      geo_json = File.read("./spec/fixtures/ea_public_face_area_#{evaluator.id_and_code}.json")
      feature = RGeo::GeoJSON.decode(geo_json)

      ea_area.code = feature.properties["code"]
      ea_area.area_id = feature.properties["identifier"]
      ea_area.name = feature.properties["long_name"]
      ea_area.area = feature.geometry
    end
  end
end

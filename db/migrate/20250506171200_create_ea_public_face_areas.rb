# frozen_string_literal: true

class CreateEaPublicFaceAreas < ActiveRecord::Migration[7.2]
  def change
    create_table :ea_public_face_areas do |t|
      t.string :area_id, null: false
      t.string :area_name, null: false
      t.string :code, null: false
      t.column :area, :geometry

      t.timestamps
    end

    add_index :ea_public_face_areas, :area_id, unique: true
    add_index :ea_public_face_areas, :code
    add_index :ea_public_face_areas, :area, using: :gist
  end
end

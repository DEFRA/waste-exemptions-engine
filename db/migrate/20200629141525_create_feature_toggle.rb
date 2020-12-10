class CreateFeatureToggle < ActiveRecord::Migration[6.0]
  def change
    create_table :feature_toggles, if_not_exists: true do |t|
      t.string :key
      t.boolean :active

      t.timestamps
    end
  end
end

class CreateFeatureToggle < ActiveRecord::Migration[6.0]
  def change
    create_table :feature_toggles do |t|
      t.string :key
      t.boolean :active

      t.timestamps
    end
  end
end

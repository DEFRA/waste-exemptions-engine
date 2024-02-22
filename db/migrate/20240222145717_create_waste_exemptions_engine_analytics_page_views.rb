class CreateWasteExemptionsEngineAnalyticsPageViews < ActiveRecord::Migration[7.0]
  def change
    create_table :analytics_page_views do |t|
      t.string :page
      t.datetime :time
      t.string :route
      t.references :user_journey, foreign_key: { to_table: :analytics_user_journeys }

      t.timestamps
    end
  end
end

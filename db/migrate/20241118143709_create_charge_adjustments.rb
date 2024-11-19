class CreateChargeAdjustments < ActiveRecord::Migration[7.1]
  def change
    create_table :charge_adjustments do |t|
      t.references :account, null: false, foreign_key: true
      t.integer :amount, null: false
      t.string :adjustment_type, null: false
      t.string :reason, null: false
      t.timestamps
    end
  end
end

class CreateWasteExemptionsEnginePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.string :payment_type
      t.integer :payment_amount
      t.string :payment_status
      t.references :order, foreign_key: true
      t.datetime :date_time
      t.string :govpay_id
      t.string :refunded_payment_govpay_id
      t.boolean :moto_payment, default: false

      t.timestamps
    end
  end
end

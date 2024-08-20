class AddOrderIdAndTotalChargeAmoutToChargeDetails < ActiveRecord::Migration[7.1]
  def change
    add_reference :charge_details, :order, foreign_key: true
    add_column :charge_details, :total_charge_amount, :integer
    add_reference :band_charge_details, :charge_detail, foreign_key: true
  end
end

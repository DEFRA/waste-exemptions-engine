class AddTempPaymentMethodToTransientRegistrations < ActiveRecord::Migration[7.1]
  def change
    add_column :transient_registrations, :temp_payment_method, :string
  end
end

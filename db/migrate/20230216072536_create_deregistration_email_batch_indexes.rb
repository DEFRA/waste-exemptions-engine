class CreateDeregistrationEmailBatchIndexes < ActiveRecord::Migration[6.1]
  def change
    add_index :registration_exemptions,
              :registration_id,
              name: "index_active_registration_ids_on_registration_exemptions",
              where: "(state = 'active')"
  end
end

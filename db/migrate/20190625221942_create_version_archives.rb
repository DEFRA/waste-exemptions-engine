# frozen_string_literal: true

# This is not used directly by Paper trail, but is created for holding paper
# trail records from the previous version of the service. Hence we have copied
# the code from the `create_versions` migration as we want a table structured
# in exactly the same way.
class CreateVersionArchives < ActiveRecord::Migration[4.2]

  # The largest text column available in all supported RDBMS is
  # 1024^3 - 1 bytes, roughly one gibibyte.  We specify a size
  # so that MySQL will use `longtext` instead of `text`.  Otherwise,
  # when serializing very large objects, `text` might not be big enough.
  TEXT_BYTES = 1_073_741_823

  def change
    create_table :version_archives do |t|
      t.string   :item_type, null: false
      t.integer  :item_id,   null: false
      t.string   :event,     null: false
      t.string   :whodunnit
      t.text     :object,    limit: TEXT_BYTES
      t.datetime :created_at
    end
    add_index :version_archives, %i(item_type item_id)
  end
end

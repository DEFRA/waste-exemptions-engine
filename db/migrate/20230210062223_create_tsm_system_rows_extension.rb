class CreateTsmSystemRowsExtension < ActiveRecord::Migration[6.1]
  def change
    enable_extension "tsm_system_rows"
  end
end

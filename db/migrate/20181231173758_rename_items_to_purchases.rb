class RenameItemsToPurchases < ActiveRecord::Migration[5.2]
  def change
    rename_table('items', 'purchases')
  end
end

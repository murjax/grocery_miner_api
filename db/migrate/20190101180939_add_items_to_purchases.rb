class AddItemsToPurchases < ActiveRecord::Migration[5.2]
  def change
    add_reference(:purchases, :item)
    remove_column(:purchases, :name)
  end
end

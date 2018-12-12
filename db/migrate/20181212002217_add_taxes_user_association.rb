class AddTaxesUserAssociation < ActiveRecord::Migration[5.2]
  def change
    add_reference :taxes, :user, foreign_key: true
  end
end

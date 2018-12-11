class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :name, limit: 255, null: false
      t.date :purchase_date, null: false
      t.decimal :price, null: false
    end
  end
end

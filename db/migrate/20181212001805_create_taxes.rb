class CreateTaxes < ActiveRecord::Migration[5.2]
  def change
    create_table :taxes do |t|
      t.date :charge_date, null: false
      t.decimal :amount, null: false
    end
  end
end

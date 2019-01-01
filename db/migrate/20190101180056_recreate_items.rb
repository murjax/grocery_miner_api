class RecreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :name, limit: 255, null: false
      t.references :user, null: false
    end
  end
end

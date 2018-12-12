class Item < ApplicationRecord
  validates :name, :price, :purchase_date, presence: true
  belongs_to :user
end

class Item < ApplicationRecord
  validates :name, presence: true
  belongs_to :user
  has_many :purchases, dependent: :restrict_with_error
end

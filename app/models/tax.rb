class Tax < ApplicationRecord
  validates :amount, :charge_date, presence: true
  belongs_to :user
end

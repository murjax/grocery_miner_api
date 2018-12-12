class Tax < ApplicationRecord
  validates :amount, :charge_date, presence: true
end

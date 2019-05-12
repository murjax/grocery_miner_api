class PurchaseResource < JSONAPI::Resource
  attributes :price, :purchase_date

  has_one :user
  has_one :item

  filter :user

  filter :month, apply: ->(records, value, _options) {
    date = Date.parse(value.first)
    start_date = date.beginning_of_month
    end_date = date.end_of_month
    records.where(purchase_date: start_date..end_date)
  }

  def self.records(options = {})
    options[:context][:current_user].purchases
  end
end

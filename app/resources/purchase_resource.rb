class PurchaseResource < JSONAPI::Resource
  attributes :price, :purchase_date

  has_one :user
  has_one :item

  before_create do
    @model.user = context[:current_user]
  end

  filter :user

  filters(:item_id)

  filter :month, apply: ->(records, value, _options) {
    date = Date.strptime(value.first, '%m/%d/%Y')
    start_date = date.beginning_of_month
    end_date = date.end_of_month
    records.where(purchase_date: start_date..end_date)
  }

  filter :year, apply: ->(records, value, _options) {
    date = Date.strptime(value.first, '%m/%d/%Y')
    start_date = date.beginning_of_year
    end_date = date.end_of_year
    records.where(purchase_date: start_date..end_date)
  }

  filter :days, apply: ->(records, value, _options) {
    start_date = Date.current - value.first.to_i.days
    records.where('purchase_date >= ?', start_date)
  }

  def self.records(options = {})
    options[:context][:current_user].purchases
  end
end

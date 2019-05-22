class ItemResource < JSONAPI::Resource
  attributes :name

  has_one :user

  filter :user

  filter :purchased_in_month, apply: ->(records, value, _options) {
    date = Date.parse(value.first)
    start_date = date.beginning_of_month
    end_date = date.end_of_month
    records.joins(:purchases).where(
      {
        purchases: { purchase_date: start_date..end_date }
      }
    )
  }

  def self.sortable_fields(context)
    super(context) + [:last_purchased, :frequent_purchased]
  end

  def self.apply_sort(records, order_options, context = {})
    if order_options.has_key?('frequent_purchased')
      records = records.select('items.*, COUNT(purchases.id) AS purchase_count')
        .joins(:purchases)
        .order("purchase_count #{order_options['frequent_purchased'].to_s}")
        .group('items.id')
      order_options.delete('frequent_purchased')
    end

    super(records, order_options, context)
  end

  def self.records(options = {})
    options[:context][:current_user].items
  end
end

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

  def self.find_records(filters, options = {})
    context = options[:context]

    records = filter_records(filters, options)

    sort_criteria = options.fetch(:sort_criteria) { [] }
    order_options = construct_order_options(sort_criteria)
    records = sort_records(records, order_options, context)

    # Everything above this is boilerplate
    #
    # We're caching the filtered & sorted recordset here, before pagination, so that we can use
    # them in the self.top_level_meta response
    @pre_paginated_records = records = sort_records(records, order_options, context)
    # Everything below this is boilerplate

    records = apply_pagination(records, options[:paginator], order_options)

    records
  end

  def self.top_level_meta(_options = {})
    {
      total_price: @pre_paginated_records.sum(:price),
      total_count: @pre_paginated_records.count
    }
  end
end

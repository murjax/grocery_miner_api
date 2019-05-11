class PurchaseResource < JSONAPI::Resource
  attributes :price, :purchase_date

  has_one :user
  has_one :item

  filter :user

  def self.records(options = {})
    options[:context][:current_user].purchases
  end
end

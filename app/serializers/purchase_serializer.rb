class PurchaseSerializer < ActiveModel::Serializer
  attributes(:id, :price, :purchase_date)
  belongs_to :item
end

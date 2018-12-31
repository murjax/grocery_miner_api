class PurchaseSerializer < ActiveModel::Serializer
  attributes(:id, :name, :price, :purchase_date)
end

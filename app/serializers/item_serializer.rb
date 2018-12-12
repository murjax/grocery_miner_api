class ItemSerializer < ActiveModel::Serializer
  attributes(:name, :price, :purchase_date)
end

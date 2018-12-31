class TaxSerializer < ActiveModel::Serializer
  attributes(:id, :amount, :charge_date)
end

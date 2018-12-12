class TaxSerializer < ActiveModel::Serializer
  attributes(:amount, :charge_date)
end

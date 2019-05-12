class PurchaseProcessor < JSONAPI::Processor
  after_find do
    total_price = @result.resources.sum do |purchase_resource|
      purchase_resource._model.price
    end
    @result.meta[:total_price] = total_price
  end
end

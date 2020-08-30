class PurchaseProcessor < JSONAPI::Processor
  after_find do
    @result.meta.merge! @resource_klass.top_level_meta(context: context)
  end
end

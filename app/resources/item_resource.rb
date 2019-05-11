class ItemResource < JSONAPI::Resource
  attributes :name

  has_one :user

  filter :user

  def self.records(options = {})
    options[:context][:current_user].items
  end
end

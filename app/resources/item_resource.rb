class ItemResource < JSONAPI::Resource
  attributes :name

  has_one :user

  filter :user
end

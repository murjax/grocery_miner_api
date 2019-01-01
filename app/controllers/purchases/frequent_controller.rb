module Purchases
  class FrequentController < ApplicationController
    before_action :authenticate_user!

    def index
      purchases = Purchase.where(user: current_user).where('purchase_date >= ?', 30.days.ago)
      items = purchases.group(:item_id).count.sort_by{ |_, value| -value }
      names = items.map do |item_data|
        item = Item.find(item_data.first)
        item.name
      end[0..4]
      render json: { names: names }, adapter: :json
    end
  end
end

module Purchases
  class TotalPerMonthController < ApplicationController
    before_action :authenticate_user!

    def index
      purchases = Purchase.where(user: current_user)

      start_date = if params[:month] && params[:year]
        Date.parse("#{params[:month]}/#{params[:year]}")
      else
        Date.current.beginning_of_month
      end

      end_date = start_date.end_of_month

      purchases = purchases.where('purchase_date >= ? AND purchase_date <= ?', start_date, end_date)

      report = purchases.pluck(:item_id).uniq.map do |item_id|
        item = Item.find(item_id)
        item_purchases = purchases.where(item: item)
        total_price = item_purchases.sum(:price)
        { name: item.name, price: total_price, count: item_purchases.count}
      end

      render json: { purchases: report }, adapter: :json
    end
  end
end

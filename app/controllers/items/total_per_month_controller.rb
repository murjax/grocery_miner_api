module Items
  class TotalPerMonthController < ApplicationController
    before_action :authenticate_user!

    def index
      items = Item.where(user: current_user)

      start_date = if params[:month] && params[:year]
        Date.parse("#{params[:month]}/#{params[:year]}")
      else
        Date.current.beginning_of_month
      end

      end_date = start_date.end_of_month

      items = items.where('purchase_date >= ? AND purchase_date <= ?', start_date, end_date)
      item_prices = items.group(:name).sum(:price)
      report = item_prices.map do |key, value|
        { name: key, price: value }
      end
      render json: { items: report }, adapter: :json
    end
  end
end

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
      purchase_prices = purchases.group(:name).sum(:price)
      report = purchase_prices.map do |key, value|
        { name: key, price: value }
      end
      render json: { purchases: report }, adapter: :json
    end
  end
end

module Purchases
  class YearlyController < ApplicationController
    before_action :authenticate_user!

    def index
      purchases = Purchase.where(user: current_user)

      if params[:year]
        start_date = Date.parse("01/01/#{params[:year]}")
      else
        start_date = Date.current.beginning_of_year
      end

      end_date = start_date.end_of_year
      purchases = purchases.where('purchase_date >= ? AND purchase_date <= ?', start_date, end_date)
      purchases = purchases.page(params[:page]).per(params[:per_page])
      render json: purchases, meta: { total_pages: purchases.total_pages }, adapter: :json
    end
  end
end

module Items
  class MonthlyController < ApplicationController
    before_action :authenticate_user!

    def index
      items = Item.where(user: current_user)

      if params[:month] && params[:year]
        start_date = Date.parse("#{params[:month]}/#{params[:year]}")
      else
        start_date = Date.current.beginning_of_month
      end

      end_date = start_date.end_of_month
      items = items.where('purchase_date >= ? AND purchase_date <= ?', start_date, end_date)
      render json: items, adapter: :json
    end
  end
end

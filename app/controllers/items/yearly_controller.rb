module Items
  class YearlyController < ApplicationController
    before_action :authenticate_user!

    def index
      items = Item.where(user: current_user)

      if params[:year]
        start_date = Date.parse("01/01/#{params[:year]}")
      else
        start_date = Date.current.beginning_of_year
      end

      end_date = start_date.end_of_year
      items = items.where('purchase_date >= ? AND purchase_date <= ?', start_date, end_date)
      render json: items, adapter: :json
    end
  end
end

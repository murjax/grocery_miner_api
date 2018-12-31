module Purchases
  class ExpenseController < ApplicationController
    before_action :authenticate_user!

    def index
      date_limit = if params[:range]
                     Date.current - params[:range].to_i.days
                   else
                     Date.current - 30.days
                   end
      purchases = Purchase.where(user: current_user)
        .where('purchase_date >= ?', date_limit)
        .order('price DESC').limit(5)
      render json: purchases, adapter: :json
    end
  end
end
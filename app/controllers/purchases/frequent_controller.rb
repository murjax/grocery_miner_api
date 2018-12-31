module Purchases
  class FrequentController < ApplicationController
    before_action :authenticate_user!

    def index
      purchases = Purchase.where(user: current_user).where('purchase_date >= ?', 30.days.ago)
      names = purchases.group(:name).count.sort_by{ |_, value| -value }.map{ |purchase| purchase.first }[0..4]
      render json: { names: names }, adapter: :json
    end
  end
end

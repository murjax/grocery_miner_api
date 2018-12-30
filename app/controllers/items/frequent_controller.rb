module Items
  class FrequentController < ApplicationController
    before_action :authenticate_user!

    def index
      items = Item.where(user: current_user).where('purchase_date >= ?', 30.days.ago)
      names = items.group(:name).count.sort_by{ |_, value| -value }.map{ |item| item.first }[0..4]
      render json: { names: names }, adapter: :json
    end
  end
end

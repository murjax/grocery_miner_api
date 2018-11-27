class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: { success: true }, adapter: :json
  end
end

class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: { success: true }, adapter: :json
  end

  def authenticate_user!(opts={})
    opts[:scope] = :user
    warden.authenticate!(opts) if !devise_controller? || opts.delete(:force)
  end
end

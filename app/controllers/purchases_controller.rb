class PurchasesController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: Purchase.where(user: current_user), adapter: :json
  end

  def show
    render json: purchase, adapter: :json
  end

  def update
    purchase.assign_attributes(permitted_params)

    if purchase.save
      render json: purchase, adapter: :json
    else
      render json: { errors: purchase.errors.to_h }, status: :unprocessable_entity
    end
  end

  def create
    purchase = Purchase.new(permitted_params)
    purchase.user = current_user
    if purchase.save
      render json: purchase, adapter: :json
    else
      render json: { errors: purchase.errors.to_h }, status: :unprocessable_entity
    end
  end

  def destroy
    head :no_content if purchase&.destroy!
  end

  private

  def purchase
    @purchase ||= Purchase.find_by!(id: params[:id], user: current_user)
  end

  def permitted_params
    params.require(:purchase).permit(:name, :price, :purchase_date, :item_id)
  end
end

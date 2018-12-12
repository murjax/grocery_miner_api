class TaxesController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: Tax.where(user: current_user), adapter: :json
  end

  def show
    render json: tax, adapter: :json
  end

  def update
    if tax.update_attributes(permitted_params)
      render json: tax, adapter: :json
    else
      render json: { errors: tax.errors.to_h }, status: :unprocessable_entity
    end
  end

  def create
    tax = Tax.new(permitted_params)
    if tax.save
      render json: tax, adapter: :json
    else
      render json: { errors: tax.errors.to_h }, status: :unprocessable_entity
    end
  end

  def destroy
    head :no_content if tax&.destroy!
  end

  private

  def tax
    @tax ||= Tax.find_by!(id: params[:id], user: current_user)
  end

  def permitted_params
    params.require(:tax).permit(:amount, :charge_date, :user_id)
  end
end

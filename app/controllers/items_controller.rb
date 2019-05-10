class ItemsController < ApplicationController
  # def index
  #   render json: Item.where(user: current_user), adapter: :json
  # end
  #
  # def show
  #   render json: item, adapter: :json
  # end
  #
  # def create
  #   item = Item.new(permitted_params)
  #   item.user = current_user
  #   if item.save
  #     render json: item, adapter: :json
  #   else
  #     render json: { errors: item.errors.to_h }, status: :unprocessable_entity
  #   end
  # end
  #
  # def update
  #   if item.update_attributes(permitted_params)
  #     render json: item, adapter: :json
  #   else
  #     render json: { errors: item.errors.to_h }, status: :unprocessable_entity
  #   end
  # end
  #
  # def destroy
  #   head :no_content if item&.destroy!
  # end
  #
  # private
  #
  # def item
  #   @item ||= Item.find_by!(id: params[:id], user: current_user)
  # end
  #
  # def permitted_params
  #   params.require(:item).permit(:name)
  # end
end

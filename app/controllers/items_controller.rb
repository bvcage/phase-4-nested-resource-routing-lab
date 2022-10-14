class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :no_record_message

  def index
    if params[:user_id]
      user = User.find_by!(id: params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  def show
    item = Item.find_by!(id: params[:id])
    render json: item, except: [:created_at, :updated_at]
  end

  def create
    item = Item.create(item_params)
    render json: item, except: [:created_at, :updated_at], status: :created
  end

  private

  def item_params
    params.permit(:name, :description, :price, :user_id)
  end

  def no_record_message
    render json: { error: 'no user found' }, status: :not_found
  end

end

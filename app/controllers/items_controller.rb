# Primary Author: Jonathan Allen (jallen01)

class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, except: [:new]
  before_action :check_permissions, except: new

  def new
    @item = Item.new
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end

  def add_user
    respond_to do |format|
      user = User.find_by(username: username)
      if user && @item.add_user(user)

      else

      end
    end
  end

  def remove_user
    respond_to do |format|
      user = User.find_by(username: username)
      if user && @item.include_user?(user)
        @item.remove_user(user)
      else
        
      end
    end
  end

  private
    def set_item
      @item = Item.find(params[:id])
    end

    # Sanitize params.
    def item_params
      params.require(:item).permit(:name)
    end

    # If current user is not in item's group, redirect to home url.
    def check_permission
      unless @item.group.include_user?(current_user)
        respond_to do |format|
          format.html { redirect_to home_path, :alert => "Forbidden to edit item." }
          format.json { render json: @item, status: :forbidden, location: home_url }
        end
      end
    end
end

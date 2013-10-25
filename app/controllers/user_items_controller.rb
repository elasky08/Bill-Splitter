# Primary Author: Jonathan Allen (jallen01)

# Controls adding/removing users in an item. All actions only return json.
class UserItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_item, except: [:create]
  before_action :check_member

  # Add user to item.
  def create
    respond_to do |format|
      user_item = @item.add_user(@user)
      if user_item
        format.json { render json: user_item, status: :created }
      else
        format.json { render status: :unprocessable_entity}
      end
    end
  end

  # Remove user from item.
  def destroy
    respond_to do |format|
      @item.remove_user(@user)
      format.json { render status: :ok }
    end
  end


  private

    def set_user_item
      @item = Item.find(params[:item_id])
      @user = User.find(params[:id])

      # If user or item does not exist, render 404.
      unless @item && @user
        respond_to do |format|
          format.json { render status: :not_found }
        end
      end 
    end

    # If current user does not have permission to edit item, render 403.
    def check_permissions
      unless item.group.include_user?(current_user)
        format.json { render status: :forbidden }
      end
    end
end

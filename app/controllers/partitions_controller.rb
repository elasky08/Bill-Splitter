# Primary Author: Jonathan Allen (jallen01)

# Controls adding/removing users in an item. All actions only return json.
class PartitionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item
  before_action :set_user, except: [:index, :create]
  before_action :check_member

  def index
    @users = @item.users
    @new_partition = Partition.new
  end

  # Add user to item.
  def create
    @user = User.find_by(email: partition_params[:email])

    # If user email is invalid, render 404.
    unless @user
      respond_to do |format|
        format.json { render status: :not_found }
      end
    end

    respond_to do |format|
      @partition = @item.add_user(@user)
      if @partition
        format.json { render json: @partition, status: :created }
      else
        format.json { render status: :unprocessable_entity}
      end
    end
  end

  # Remove user from item.
  def destroy
    @item.remove_user(@user)
    @users = @item.users

    respond_to do |format|
      format.js
      format.json { render status: :ok }
    end
  end


  private
    def set_item
      @item = Item.find_by(id: params[:item_id])

      # If item id is invalid, render 404.
      unless @item
        respond_to do |format|
          format.json { render status: :not_found }
        end
      end
    end

    def set_user
      @user = User.find_by(id: params[:id])

      # If user or item does not exist, render 404.
      unless @user
        respond_to do |format|
          format.json { render status: :not_found }
        end
      end 
    end

    # If current user does not have permission to edit item, render 403.
    def check_member
      unless @item.group.include_user?(current_user)
        respond_to do |format|
          format.json { render status: :forbidden }
        end
      end
    end

    def partition_params
      params.require(:partition).permit(:email)
    end
end
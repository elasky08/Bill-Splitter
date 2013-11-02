# Primary Author: Jonathan Allen (jallen01)

# Controls adding/removing users in an item. All actions only return json.
class PartitionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_partition, except: [:create]
  before_action :check_membership, except: [:create]

  def show
    @new_partition = Partition.new
  end

  # Add user to item.
  def create
    user = User.find_by(email: partition_params[:email])
    item = Item.find_by(id: partition_params[:item_id])

    respond_to do |format|
      # If user email is invalid, render 404.
      unless user && item
        respond_to do |format|
          self.errors.add(:email, "does not exist")
          format.js
          format.json { render status: :not_found }
        end
      end

      @new_partition = item.add_user(user)
      if @new_partition.save
        @partition = @new_partition
        @new_partition = Partition.new
        format.js
        format.json { render json: @partition, status: :created }
      else
        format.js
        format.json { render json: @new_partition.errors, status: :unprocessable_entity }
      end
  end

  # Remove user from item.
  def destroy
    @partition.item.remove_user(@partition.user)
    @users = @partition.item.users

    respond_to do |format|
      format.js
      format.json { render status: :ok }
    end
  end


  private
    def set_partition
      @partition = Partition.includes(:users).find_by(id: params[:id])

      # If user or item does not exist, render 404.
      unless @partition
        respond_to do |format|
          format.json { render status: :not_found }
        end
      end 
    end

    # If current user does not have permission to edit item, render 403.
    def check_membership
      unless @item.group.is_member?(current_user)
        respond_to do |format|
          format.json { render status: :forbidden }
        end
      end
    end

    def partition_params
      params.require(:partition).permit(:email)
    end
end
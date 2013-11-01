# Primary Author: Jonathan Allen (jallen01)

# Controls adding/removing users in a group. Also controls user payments to a group. All actions only return json.
class GroupUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_user, except: [:index, :create]

  def index
    @new_group_user = @group.users.new
  end

  # Add user to group
  def create
    @user = User.find_by(email: group_user_params[:email])

    respond_to do |format|
      # If user id or group id is invalid, render 404.
      unless @user
        format.js { render "groups/" }
        format.json { render status: :not_found }
      end 

      # If current user does not have permission to add user to group, render 403.
      unless @group.owner == current_user
        format.html {  }
        format.json { render status: :forbidden }
      end

      @group_user = @group.add_user(user)
      if @group_user
        format.json { render json: @group_user, status: :created }
      else
        format.json { render status: :unprocessable_entity }
      end
    end
  end

  # Show user personal bill
  def show
    @group_user = @group.get_group_user(@user)
    @items = @group.get_user_items(@user)
    @items_total = @group.get_user_items_total(@user)
  end

  # Update user payment to group
  def update
    # If current user does not have permission to update payment, render 403.
    unless @user == current_user
      format.json { render status: :forbidden }
    end

    respond_to do |format|
      group_user = @group.get_group_user(@user)
      if group_user.update(payment: group_user_params[:payment])
        format.json { render status: :ok }
      else
        format.json { render json: group_user.errors, status: :unprocessable_entity}
      end
    end
  end

  # Remove user from group
  def destroy
    respond_to do |format|
      # If current user does not have permission to remove user from group, render 403.
      unless [@group.owner, @user].include?(current_user)
        format.json { render status: :forbidden }
      end

      @group.remove_user(user)
        
      format.json { render status: :ok }
    end
  end

  private
    def set_group
      @group = Group.includes(:group_users, :users).find(id: params[:group_id])

      # If group does not exist, render 404.
      unless @group
        respond_to do |format|
          format.json { render status: :not_found }
        end
      end
    end

    def set_user
      @user = User.find(id: params[:id])

      # If user does not exist, render 404.
      unless @user
        respond_to do |format|
          format.json { render status: :not_found }
        end
      end 
    end

    # Sanitize params.
    def group_user_params
      params.require(:group_user).permit(:email, :payment)
    end
end

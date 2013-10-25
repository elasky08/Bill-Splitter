# Primary Author: Jonathan Allen (jallen01)

# Controls adding/removing users in a group. Also controls user payments to a group. All actions only return json.
class GroupUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group_user, except: [:create]

  # Add user to group
  def create
    group = Group.find(params[:group_id])
    user = User.find(params[:id])

    # If user id or group id is invalid, render 404.
    unless user && group
      format.json { render status: :not_found }
    end 

    # If current user does not have permission to add user to group, render 403.
    unless [group.owner].include?(current_user)
      format.json { render status: :forbidden }
    end

    respond_to do |format|
      group_user = group.add_user(user)
      if group_user
        format.json { render json: group_user, status: :created }
      else
        format.json { render status: :unprocessable_entity }
      end
    end
  end

  # Update user payment to group
  def update
    # If current user does not have permission to update payment, render 403.
    unless [@user].include?(current_user)
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
    # If current user does not have permission to remove user from group, render 403.
    unless [@group.owner, @user].include?(current_user)
      format.json { render status: :forbidden }
    end

    respond_to do |format|
      @group.remove_user(user)
      format.json { render status: :ok }
    end
  end

  private
    def set_group_user
      @group = Group.find(params[:group_id])
      @user = User.find(params[:id])

      # If group or user does not exist, render 404.
      unless @group && @user
        respond_to do |format|
          format.json { render status: :not_found }
        end
      end 
    end

    # Sanitize params.
    def group_user_params
      params.require(:group_user).permit(:payment)
    end
end

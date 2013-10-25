# Primary Author: Jonathan Allen (jallen01)

# Controls adding/removing users in a group. Also controls user payments to a group.
class GroupUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group_user
  before_action :check_url

  def create
    group = Group.find(params[:group_id])
    user = User.find(params[:id])

    

    # If user id or group id is invalid redirect, and throw 404 code.
    unless user && group
      format.json { render status: :not_found }
    end 

    respond_to do |format|
      group_user = group.add_user(user)
      if group_user
        format.json { render json: group_user, status: :ok }
      else
        format.json { render status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @group_user.update(group_user_params)
        format.json { render status: :ok }
      else
      end
    end
  end

  def destroy
    respond_to do |format|
      user = User.find_by(username: username)
      # Check that current user is either group owner or user being removed
      if [@group.owner, user].include?(current_user)
        if user
          @group.remove_user(user)
          format.json { render status: :ok }
        else
          format.json { render status: :unprocessable_entity }
        end
      else
        format.json { render status: :forbidden }
      end
    end
  end

  private
    def set_group_user
      @group_user = GroupUser.find_by(group_id: params[:group_id], user_id: params[:id])

      # If group id is invalid redirect, and throw 404 code.
      unless @group_user
        respon_to do |format|
          format.json { render status: :not_found }
        end
      end 
    end

    def group_user_params
      params.require(:group_user).permit(:payment)
    end
end

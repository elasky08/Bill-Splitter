# Primary Author: Jonathan Allen (jallen01)

# Controls adding/removing users in a group. Also controls user payments to a group. All actions only return json.
class MembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_membership

  # Show user personal bill
  def show
    @user_items = @group.get_user_items(@user)
    @user_total = @group.get_user_total(@user)
  end

  # Update user payment to group
  def update
    # Check that user is current user.
    unless @membership.user == current_user
      flash.alert = "Forbidden: must be user."
      format.js { render js: "window.location.href = '#{group_url(@group)}'" }
    end

    @membership.update(payment: membership_params[:payment])
    respond_to do |format|
      format.js
    end
  end

  private
    def set_group
      @group = Group.includes(:memberships, :users).find_by(id: params[:group_id])

      # If group does not exist, render 404.
      unless @group
        respond_to do |format|
          flash.alert = "Group not found."
          format.js { render js: "window.location.href = '#{groups_url}'" }
        end
      end
    end

    def set_membership
      @membership = Membership.find_by(id: params[:id])

      # Check that user exists.
      unless @membership
        respond_to do |format|
          flash.alert = "Membership not found."
          format.js { render js: "window.location.href = '#{group_url(@group)}'" }
        end
      end 
    end

    # Sanitize params.
    def membership_params
      params.require(:membership).permit(:email, :payment)
    end

    def check_ownership
      # If current user does not have permission to add user to group, redirect.
      unless @group.owner == current_user
        flash.alert = "Forbidden: must be owner."
        format.js { render js: "window.location.href = '#{group_url(@group)}'" }
      end
    end
end

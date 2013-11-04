# Primary Author: Jonathan Allen (jallen01)

# Controls adding/removing users in a group. Also controls debtors. All actions only return js.
class MembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_membership
  before_action :check_permissions

  # Show user personal bill
  def show
    @total_bill = [current_user, @membership.debtor_users].flatten(1).sum { |user| @group.get_user_total(user) }
    @other_members = @group.users.where.not(id: current_user)
  end

  def add_debtor
    user = User.find_by(id: params[:debtor_id])

    # Check that user exists
    if not user
      @membership.errors.add(:debtor_id, "does not exist")

    # Check that user is in group.
    elsif not @group.includes_user?(user)
      @membership.errors.add(:debtor_id, "is not a member of the group")

    else
      @group.get_membership(user).update_attribute(:creditor, @membership)
    end

    @other_members = @group.users.where.not(id: current_user)

    respond_to do |format|
      format.js
    end
  end

  def remove_debtor
    user = User.find_by(id: params[:debtor_id])

    # Check that user exists and membership user is user's creditor
    if user &&  @group.get_membership(user).creditor == @membership
      @group.get_membership(user).update_attribute(:creditor, nil)
    end

    @other_members = @group.users.where.not(id: current_user)

    respond_to do |format|
      format.js
    end
  end

  private
    def set_group
      @group = Group.find_by(id: params[:group_id])

      # Check that group exists.
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
      params.require(:membership).permit(:email)
    end

    def check_permissions
      # Check that user is current user.
      unless @membership.user == current_user
        flash.alert = "Forbidden: must be user."
        format.js { render js: "window.location.href = '#{group_url(@group)}'" }
      end
    end
end

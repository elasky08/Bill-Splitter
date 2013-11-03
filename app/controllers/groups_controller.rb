# Primary Author: Jonathan Allen (jallen01)

class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, except: [:index, :create]
  before_action :check_membership, only: [:show, :cost]
  before_action :check_ownership, only: [:update, :destroy, :add_user]

  def index
    @groups = current_user.groups.ordered
    @new_group = Group.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @new_item = Item.new
    @new_membership = Membership.new
  end

  def create
    @new_group = current_user.owned_groups.new(group_params)
    @new_group.save
    respond_to do |format|
      format.js
    end
  end

  def update
    @group.update(group_params)
    self.show

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @group.destroy
    self.index

    respond_to do |format|
      format.js
      format.html { redirect_to groups_url }
    end
  end

  def add_user
    user = User.find_by(email: params[:email].downcase)
    @new_membership = Membership.new
    
    # Check that user exists
    if user.blank?
      @new_membership.errors.add(:email, "does not exist")
    else
      @group.add_user(user)
    end

    respond_to do |format|
      format.js
    end
  end

  def remove_user
    user = User.find_by(id: params[:user_id])

    # Check that user is not group owner.
    if user == @group.owner
      respond_to do |format|
        flash.alert = "Cannot remove owner of group."
        format.js { render js: "window.location.href = '#{group_url(@group)}'" }
      end
    end

    if user
      @group.remove_user(user)
    end

    respond_to do |format|
      format.js
    end
  end

  private
    def set_group
      @group = Group.find_by(id: params[:id])

      # Check that group exists.
      unless @group
        respond_to do |format|
          flash.alert = "Group not found."
          format.js { render js: "window.location.href = '#{groups_url}'" }
          format.html { redirect_to groups_url }
        end
      end 
    end

    # Sanitize params.
    def group_params
      params.require(:group).permit(:name)
    end

    # Check that current user is a member of the group.
    def check_membership
      unless @group.includes_user?(current_user)
        respond_to do |format|
          flash.alert = "Forbidden: must be a member."
          format.js { render js: "window.location.href = '#{groups_url}'" }
          format.html { redirect_to groups_url }
        end
      end
    end

    # Check that current user is the owner of the group.
    def check_ownership
      unless @group.owner == current_user
        respond_to do |format|
          flash.alert = "Forbidden: must be owner."
          format.js { render js: "window.location.href = '#{group_url(@group)}'" }
          format.html { redirect_to group_url(@group) }
        end
      end
    end
end

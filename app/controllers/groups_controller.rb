# Primary Author: Jonathan Allen (jallen01)

class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, except: [:index, :create]
  before_action :check_membership, only: [:show, :cost]
  before_action :check_ownership, only: [:update, :destroy, :add_user]

  def index
    @groups = current_user.groups.ordered
    @new_group = Group.new
  end

  def show
    @items = @group.items
    @new_item = Item.new
    @membership = @group.get_membership(current_user)
    @new_membership = Membership.new
  end

  def create
    @new_group = current_user.owned_groups.new(group_params)

    respond_to do |format|
      if @new_group.save
        format.js { render js: "window.location.href = '#{group_url(@new_group)}'" }
      else
        format.js
      end
    end
  end

  def update
    @group.update(group_params)

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @group.destroy
    @groups = current_user.groups.ordered

    respond_to do |format|
      format.js
    end
  end

  def add_user
    user = User.find_by(email: params[:email])
    @new_membership = Membership.new

    respond_to do |format|
      # Check that user exists
      unless user
        @new_membership.errors.add(:email, "does not exist")
        format.js
      end

      @group.add_user(user)
      format.js
    end
  end

  def remove_user
    user = User.find_by(id: params[:user_id])

    if user
      @item.remove_user(user)
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
        end
      end
    end

    # Check that current user is the owner of the group.
    def check_ownership
      unless @group.owner == current_user
        respond_to do |format|
          flash.alert = "Forbidden: must be owner."
          format.js { render js: "window.location.href = '#{group_url(@group)}'" }
        end
      end
    end
end

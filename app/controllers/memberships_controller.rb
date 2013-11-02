# Primary Author: Jonathan Allen (jallen01)

# Controls adding/removing users in a group. Also controls user payments to a group. All actions only return json.
class MembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_user, except: [:index, :create]

  def index
    @new_membership = Membership.new
  end

  # Add user to group
  def create
    @user = User.find_by(email: membership_params[:email])

    respond_to do |format|
      # If user id or group id is invalid, render 404.
      unless @user
        format.json { render status: :not_found }
      end 

      # If current user does not have permission to add user to group, render 403.
      unless @group.owner == current_user
        format.json { render status: :forbidden }
      end

      @new_membership = @group.add_user(user)
      if @new_membership
        @membership = @new_membership
        @new_membership = Membership.new

        format.js
        format.json { render json: @membership, status: :created }
      else
        format.js
        format.json { render status: :unprocessable_entity }
      end
    end
  end

  # Show user personal bill
  def show
    @membership = @group.get_membership(@user)
    @items = @group.get_partitions(@user)
    @items_total = @group.get_partitions_total(@user)
  end

  # Update user payment to group
  def update
    # If current user does not have permission to update payment, render 403.
    unless @user == current_user
      format.json { render status: :forbidden }
    end

    respond_to do |format|
      membership = @group.get_membership(@user)
      if membership.update(payment: membership_params[:payment])
        format.json { render status: :ok }
      else
        format.json { render json: membership.errors, status: :unprocessable_entity}
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
      @group = Group.includes(:memberships, :users).find_by(id: params[:group_id])

      # If group does not exist, render 404.
      unless @group
        respond_to do |format|
          format.json { render status: :not_found }
        end
      end
    end

    def set_user
      @user = User.find_by(id: params[:id])

      # If user does not exist, render 404.
      unless @user
        respond_to do |format|
          format.json { render status: :not_found }
        end
      end 
    end

    # Sanitize params.
    def membership_params
      params.require(:membership).permit(:email, :payment)
    end
end

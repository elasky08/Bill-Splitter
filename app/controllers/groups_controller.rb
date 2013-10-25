# Primary Author: Jonathan Allen (jallen01)

class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, except: [:index, :new]
  before_action :check_member, only: [:show]
  before_action :check_owner, only: [:update, :destroy, :add_user]

  def index
    @groups = current_user.groups.ordered
  end

  def show
    @group = @group.includes(:item)
  end

  def new
    @group = Group.new(owner: current_user)
  end

  def edit
    @group = @group.includes(:user)
  end

  def create
    @group = current_user.owned_groups.create.new(group_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group created.' }
        format.json { render action: 'show', status: :created, location: group_url(@group) }
      else
        format.html { render action: 'new' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to group_url(@group), notice: 'Group updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to home_url }
      format.json { head :no_content }
    end
  end

  def add_user
    respond_to do |format|
      user = User.find_by(username: username)
      if user && @group.add_user(user)
        format.json { render json: group, status: :accepted }
      else
        format.json { render json: group, status: :unprocessable_entity }
      end
    end
  end

  def remove_user
    respond_to do |format|
      user = User.find_by(username: username)
      # Check that current user is either group owner or user being removed
      if [@group.owner, user].include?(current_user)
        if user
          @group.remove_user(user)
          format.json { render json: group, status: :accepted }
        else
          format.json { render json: group, status: :unprocessable_entity }
        end
      else
        format.json { render json: @group, status: :forbidden, location: home_url }
      end
    end
  end
  
  private
    def set_group
      @group = Group.find(params[:id])
    end

    # Sanitize params.
    def group_params
      params.require(:group).permit(:name)
    end

    # If current user is not in group, redirect to home url.
    def check_member
      unless @group.include_user(current_user)
        respond_to do |format|
          format.html { redirect_to home_url, alert: 'Forbidden to view group.' }
          format.json { render json: @group, status: :forbidden, location: home_url }
        end
      end
    end

    # If current user is not group owner, redirect to group url.
    def check_owner
      unless current_user == @group.owner
        respond_to do |format|
          format.html { redirect_to group_url(@group), alert: 'Forbidden to edit group.' }
          format.json { render json: @group, status: :forbidden, location: group_url(@group) }
        end
      end
    end
end

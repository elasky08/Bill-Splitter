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
        format.json { render action: 'show', status: :created, location: @group }
      else
        format.html { render action: 'new' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group updated.' }
        format.json { render status: :ok }
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

  
  
  private
    def set_group
      @group = Group.find(params[:id])

      # If group id is invalid redirect, and throw 404 code.
      unless @group
        format.html { redirect_to home_url, status: :not_found }
        format.json { render status: :not_found }
      end 
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
          format.html { redirect_to @group, alert: 'Forbidden to edit group.' }
          format.json { render json: @group, status: :forbidden, location: @group }
        end
      end
    end
end

# Primary Author: Jonathan Allen (jallen01)

class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, except: [:index, :create]
  before_action :check_member, only: [:show, :cost]
  before_action :check_owner, only: [:update, :destroy, :add_user]

  def index
    @groups = current_user.groups.ordered
    @new_group = Group.new
  end

  def show
    @items = @group.items
    @new_item = Item.new
  end

  def create
    @group = current_user.owned_groups.new(group_params)
    @new_group = Group.new

    respond_to do |format|
      if @group.save        
        format.js
        format.json { render action: 'show', status: :created, location: @group }
      else
        format.js
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @group.update(group_params)
        format.js
        format.json { render json: @group, status: :ok }
      else
        format.js
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @group.destroy
    @groups = current_user.groups.ordered
    
    respond_to do |format|
      format.html { redirect_to groups_url }
      format.js
      format.json { render json: {}, status: :ok, location: groups_url }
    end
  end

  private
    def set_group
      @group = Group.find_by(id: params[:id])

      # If group id is invalid redirect, and throw 404 code.
      unless @group
        respond_to do |format|
          format.html { redirect_to groups_url }
          format.json { render json: {}, status: :not_found, location: groups_url }
        end
      end 
    end

    # Sanitize params.
    def group_params
      params.require(:group).permit(:name)
    end

    # If current user is not in group, redirect to home url.
    def check_member
      unless @group.include_user?(current_user)
        respond_to do |format|
          format.html { redirect_to groups_url }
          format.json { render json: {}, status: :forbidden, location: groups_url }
        end
      end
    end

    # If current user is not group owner, redirect to group url.
    def check_owner
      unless @group.owner == current_user
        respond_to do |format|
          format.html { redirect_to @group }
          format.json { render status: :forbidden, location: @group }
        end
      end
    end
end

class GroupUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_user

  def create
    respond_to do |format|
      user = User.find(params[:id])
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
      @group = Group.find(params[:group_id])
      # If url slug is old, redirect to current one.
      if request_path != article_path(@article)
        respond_to do |format|
          format.html { redirect_to @group, status: :moved_permanently }
          format.json { render json: @group, status: :moved_permanently, location @group }
        end
    end
end

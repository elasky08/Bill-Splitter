class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, except: [:index, :new]

  def index
    @groups = current_user.groups
  end

  def show
  end

  def new
    @group = Group.new(owner: current_user)
  end

  def edit
  end

  def create
    @group = Group.new(owner)

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was created.' }
      else
        format.html { render action: 'new' }
      end
  end

  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was created.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url}
    end
  end

  def add_user
    respond_to do |format|
      user = User.find_by(username: username)
      if user && @group.add_user(user)

      else

      end
    end
  end

  def remove_user
    respond_to do |format|
      user = User.find_by(username: username)
      if user && @group.remove_user(user)

      else
        
      end
    end
  end

  def index

  end
  
  private
    def set_group
      @group = Group.find(params[:id])
    end

    # Sanitize params.
    def group_params
      params.require(:group).permit(:name)
    end
end

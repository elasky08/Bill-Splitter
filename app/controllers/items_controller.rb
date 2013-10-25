class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, except: [:new]
  before_action :check_permissions, except: new

  def new
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end

  def add_user
    respond_to do |format|
      user = User.find_by(username: username)
      if user && @item.add_user(user)

      else

      end
    end
  end

  def remove_user
    respond_to do |format|
      user = User.find_by(username: username)
      if user && @item.remove_user(user)

      else
        
      end
    end
  end

  private
    def set_item
      @item = Item.find(params[:id])
    end

    # Sanitize params.
    def item_params
      params.require(:item).permit(:name)
    end

    def check_permission
      unless @item.group.include? current_user
        redirect_to home_path, :alert => "You don't have permission to modify that item."
      end
    end
end

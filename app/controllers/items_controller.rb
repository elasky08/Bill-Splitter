# Primary Author: Jonathan Allen (jallen01)

class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, except: [:new]
  before_action :check_permissions, except: new

  def new
    @item = Item.new
  end

  def edit
  end

  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to item_url(@item), notice: 'Item created.' }
        format.json { render action: 'show', status: :created, location: item_url(@item) }
      else
        format.html { render action: 'new' }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to item_url(@item), notice: 'Item updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    group = item.group
    @item.destroy
    respond_to do |format|
      format.html { redirect_to group_url(group) }
      format.json { head :no_content }
    end
  end

  def add_user
    respond_to do |format|
      user = User.find_by(username: username)
      if user && @item.add_user(user)
        format.json { render json: item, status: :accepted }
      else
        format.json { render json: item, status: :unprocessable_entity}
      end
    end
  end

  def remove_user
    respond_to do |format|
      user = User.find_by(username: username)
      if user
        @item.remove_user(user)
        format.json { render json: item, status: :accepted }
      else
        format.json { render json: item, status: :unprocessable_entity }
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

    # If current user is not in item's group, redirect to home url.
    def check_permission
      unless @item.group.include_user?(current_user)
        respond_to do |format|
          format.html { redirect_to home_path, :alert => "Forbidden to edit item." }
          format.json { render json: @item, status: :forbidden, location: home_url }
        end
      end
    end
end

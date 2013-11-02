# Primary Author: Jonathan Allen (jallen01)

# Controls adding/removing items in a group. All actions only return json.
class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_item, except: [:create]
  before_action :check_membership

  def edit
  end
  
  def create
    @new_item = @group.edit_item_by_name(item_params[:name], item_params[:cost])

    if @new_item.save
      @items = @group.items
      @item = @new_item
      @new_item = Item.new
    end
    
    respond_to do |format|
      format.js
    end
  end

  def update
    @item.update(item_params)
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @item.destroy
    @items = @group.items

    respond_to do |format|
      format.js
    end
  end

  private
    def set_group
      @group = Group.find_by(id: params[:group_id])

      # Check that group exists.
      unless @group
        respond_to do |format|
          flash.alert = "Group not found."
          format.js { render js: "window.location.href = '#{groups_url}'" }
        end
      end
    end

    def set_item
      @item = Item.find_by(id: params[:id])

      # Check that item exists.
      unless @item
        respond_to do |format|
          flash.alert = "Item not found."
          format.js { render js: "window.location.href = '#{group_url(@group)}'" }
        end
      end 
    end

    # Sanitize params.
    def item_params
      params.require(:item).permit(:name, :cost)
    end

    # Check that user is a member of the item's group.
    def check_membership
      unless @group.is_member?(current_user)
        respond_to do |format|
          flash.alert = "Forbidden: must be a member."
          format.js { render js: "window.location.href = '#{groups_url}'" }
        end
      end
    end
end

# Primary Author: Jonathan Allen (jallen01)

# Controls adding/removing items in a group. All actions only return json.
class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_item, except: [:create]
  before_action :check_member

  def edit
  end
  
  def create
    @new_item = @group.edit_item_by_name(item_params[:name], item_params[:cost])
    
    respond_to do |format|
      if @new_item.save
        @items = @group.items
        @new_item = Item.new
        
        format.js
        format.json { render json: @new_item, status: :created }
      else
        format.js
        format.json { render json: @new_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @item.update(item_params)
        format.js
        format.json { render json: @item, status: :ok }
      else
        format.js
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @item.destroy
    @items = @group.items

    respond_to do |format|
      format.js
      format.json { render json: {}, status: :ok }
    end
  end

  private
    def set_group
      @group = Group.find_by(id: params[:group_id])

      # If group id is invalid, render 404.
      unless @group
        respond_to do |format|
          format.json { render json: {}, status: :not_found }
        end
      end
    end

    def set_item
      @item = Item.find_by(id: params[:id])

      # If item id is invalid, render 404.
      unless @item
        respond_to do |format|
          format.json { render json: {}, status: :not_found }
        end
      end 
    end

    # Sanitize params.
    def item_params
      params.require(:item).permit(:name, :cost)
    end

    # If current user is not in item's group, render 403.
    def check_member
      unless @group.include_user?(current_user)
        respond_to do |format|
          format.json { render json: {}, status: :forbidden }
        end
      end
    end
end

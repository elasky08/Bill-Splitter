class ItemsController < ApplicationController
  before_action :authenticate_user!

  private
    # Sanitize params.
    def item_params
      params.require(:item).permit(:name)
    end
end

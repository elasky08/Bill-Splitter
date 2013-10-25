class GroupsController < ApplicationController
  before_action :authenticate_user!

  private
    # Sanitize params.
    def group_params
      params.require(:group).permit(:name)
    end
end

class UsersController < ApplicationController

  private
    # Sanitize params.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end

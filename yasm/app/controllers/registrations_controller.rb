class RegistrationsController < Devise::RegistrationsController
  private

  def sign_up_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:username, :about, :avatar, :email, :password,
                                 :password_confirmation, :current_password)
  end

  def update_resource(resource, params)
    if !current_user.provider.nil?
      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end
  end
end

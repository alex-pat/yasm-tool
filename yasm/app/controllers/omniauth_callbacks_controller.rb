class OmniauthCallbacksController < ApplicationController
  def facebook
    authorize("Facebook")
  end

  def vkontakte
    authorize("Vkontakte")
  end

  def twitter
    authorize("Twitter")
  end

  private
  def authorize(kind)
    @user = User.find_for_oauth request.env["omniauth.auth"]
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => kind
      sign_in_and_redirect @user, :event => :authentication
    else
      flash[:notice] = "authentication error"
      redirect_to root_path
    end
  end
end

require 'test_helper'

class Users::OmniauthCallbacksControllerTest < ActionDispatch::IntegrationTest
  test "should get facebook" do
    get users_omniauth_callback_facebook_url
    assert_response :success
  end

  test "should get vkontakte" do
    get users_omniauth_callback_vkontakte_url
    assert_response :success
  end

  test "should get twitter" do
    get users_omniauth_callback_twitter_url
    assert_response :success
  end

end

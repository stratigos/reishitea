require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  test "Should Get Index" do
    get :index
    assert_response :success
  end

  test "Should Get Info" do
    get :info
    assert_response :success
  end

  test "Should Get Custom Info Route" do
    assert_routing '/reishi-information', :controller => 'welcome', :action => 'info'
  end

  test "Should Get About" do
    get :about
    assert_response :success
  end

end

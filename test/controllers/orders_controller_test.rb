require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  test "Can Get Index" do
    get :index
    assert_response :success
  end

  test "Can Post to Create" do
    post :create
    assert_response :success
  end

end

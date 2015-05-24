require 'test_helper'

class OrdersControllerTest < ActionController::TestCase

  setup do
    @post_order = { order: { name: 'Name', street: '123 Street St', city: 'Derp', state: 'Derptucky', country: 'Derpia', 
                           postal: 12345, quantity: 12 } }
  end
  
  test "Can Get Index" do
    get :index
    assert_response :success
  end

  test "Can Get New" do
    get :new
    assert_response :success
  end

  test "Can Post to Create and Get Successful Redirect" do
    post :create, @post_order

    assert_equal response.location, orders_index_url
    assert_equal response.status,   302
  end

  teardown do
    @post_order = nil
  end

end

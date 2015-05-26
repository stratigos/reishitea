require 'test_helper'

class OrderNewContentTest < ActionDispatch::IntegrationTest
  # Tests that the orders/new page loads, has appropriate content type, has
  #  just one form specific to new orders, has appropriate inputs, and uses
  #  the expected template.  
  test 'New Order Page Has Expected Content' do
    get orders_new_path

    assert_equal    200,             response.status
    assert_equal    Mime::HTML,      response.content_type
    assert_select   'form',          1
    assert_select   'form[id=?]',    'new_order'
    assert_select   'input[type=?]', 'text',    count: 7
    assert_select   'input[type=?]', 'submit',  count: 1
    assert_template 'orders/new'
  end
end

require 'test_helper'

class OrderIndexContentTest < ActionDispatch::IntegrationTest
  # Tests that /orders loads, has expected content type, has two links to make
  #  a new Order, and contains appropriate HTML containers for displaying the 
  #  recent Order data. 
  test 'Order Index Page Has Expected Content' do
    get orders_root_path

    assert_equal    200,            response.status
    assert_equal    Mime::HTML,     response.content_type
    assert_select   'a[href=?]',    orders_new_path,        count: 2
    assert_select   'div[id=?]',    'orders-index-content', count: 1
    assert_select   'div',          :class => /recent-orders-container/ 
    assert_select   'div',          :class => /recent-sold-container/
    assert_select   'div',          :class => /recent-shipped-container/ 
    assert_template 'orders/index'
  end
end

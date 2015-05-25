require 'test_helper'

class OrderPusherEventTest < ActionDispatch::IntegrationTest

  # Tests that an Order is created and saved correctly, and no errors are
  #  returned. 
  test 'Can Create Order and Publish Event to Pusher' do
    @order = Order.create({ :name => 'Test Pusher', :street => '123 Pusher Ave', :city => 'Pusherville',
                            :state => 'New Push', :postal => '54321', :country => 'Pusheria', :quantity => 4 })

    assert     @order.errors.empty?
    assert_not @order.new_record?

  end

end

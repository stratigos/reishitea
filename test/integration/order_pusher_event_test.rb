require 'test_helper'

class OrderPusherEventTest < ActionDispatch::IntegrationTest

  # TODO: complete setup for listening to Pusher event after Order created.
  setup do
    # @pusher_event = false

    # # Setting up async event listening
    # require 'pusher-client'
    # @socket = PusherClient::Socket.new('649001c97497e1020b78')
    # @socket.connect(true) # Connect asynchronously

    # # Subscribe to the default channel for this environment
    # @socket.subscribe(Rails.configuration.x.pusher.channel)

    # # Bind to a channel event (can only occur on channel1)
    # @socket[Rails.configuration.x.pusher.channel].bind(Order::PUSHER_EVENT_ORDER_RECIEVED) do |data|
    #   @pusher_event = true
    # end
  end

  # Tests that an Order is created and saved correctly,
  #  and no errors are returned. 
  # TODO: complete test for listening to Pusher event after Order created.
  test 'Can Create Order and Publish Event to Pusher' do
    @order = Order.create({ :name => 'Test Pusher', :street => '123 Pusher Ave', :city => 'Pusherville',
                            :state => 'New Push', :postal => '54321', :country => 'Pusheria', :quantity => 4 })

    # sleep(5.seconds) # not a healthy way to test for async events

    # assert     @pusher_event
    assert     @order.errors.empty?
    assert_not @order.new_record?

  end

  # TODO: teardown the steup for listening to Pusher event after Order created.
  teardown do
    # @socket.disconnect
  end

end

require 'test_helper'

class OrderTest < ActiveSupport::TestCase

  setup do
    @new_order      = Order.new
    @orders_today   = Order.today.all
    @orders_ready   = Order.ready_for_shipping.all
    @orders_shipped = Order.shipped.all
  end

  test 'Can Select an Order with its Comment' do
    assert @orderwithcomment
    assert_not_nil @orderwithcomment.comment
  end

  # Test scopes. Mainly focusing on scopes with comparison operands in queries.
  test 'Selects "today" Orders' do
    assert_equal @orders_today.count, 3
  end

  test 'Selects "shipped" Orders' do
    assert_equal @orders_shipped.count, 22
  end

  test 'Selects "ready_for_shipping" Orders' do
    assert_equal @orders_ready.count, 2
  end

  # Test validations. Mainly focusing on validation callbacks that contain 
  #  custom evaluations (i.e., regular expressions), or which implement
  #  business logic.
  test 'Validates Not Enough Quantity' do
    @new_order.quantity = 0
    @new_order.wont_be :valid?
    @new_order.errors[:quantity].must_equal ['must be greater than 0']
  end

  test 'Validates Too Many Quantity' do
    @new_order.quantity = 101
    @new_order.wont_be :valid?
    @new_order.errors[:quantity].must_equal ['must be less than 101']
  end

  test 'Validates No Partial Orders' do
    @new_order.quantity = 1.25
    @new_order.wont_be :valid?
    @new_order.errors[:quantity].must_equal ['must be an integer']
  end

  test 'Validates Postal Code is Numeric' do
    @new_order.postal = 'One Two Three Four Five'
    @new_order.wont_be :valid?
    @new_order.errors[:postal].must_equal ['Invalid Postal Code']
  end

  test 'Validates Postal Code is Long Enough' do
    @new_order.postal = 1234
    @new_order.wont_be :valid?
    @new_order.errors[:postal].must_equal ['Invalid Postal Code']
  end

  test 'Validates Postal Code not Too Long' do
    @new_order.postal = 123456
    @new_order.wont_be :valid?
    @new_order.errors[:postal].must_equal ['Invalid Postal Code']
  end

  # @todo Update table 'orders' such that 'orders.postal' is a varchar
  # test 'Validates Add-on Postal Code is Long Enough' do
  #   @new_order.postal = '12345-678'
  #   puts @new_order.inspect
  #   @new_order.wont_be :valid?
  #   @new_order.errors[:postal].must_equal ['Invalid Postal Code']
  # end

  # test 'Validates Add-on Postal Code not Too Long' do
  #   @new_order.postal = '12345-67890'
  #   puts @new_order.inspect
  #   @new_order.wont_be :valid?
  #   @new_order.errors[:postal].must_equal ['Invalid Postal Code']
  # end

  # Test Callbacks
  test 'Can call send_pusher' do
    sent = @new_order.send(:send_pusher)
    assert sent
  end

  test 'Can call send_pusher_shipment' do
    sent = @new_order.send(:send_pusher_shipment)
    assert sent
  end

  # Tests Order::ship by setting created_at 4 hours in the past (3 hours
  #  is needed for shipping to process and take place, its a pretend business
  #  rule).
  # Asserts that Order::ship returns TRUE for an instance with the right
  #  conditions, and that the Order.shipped value is updated. 
  test 'Can Ship an Order' do
    shipped = @ordernotyetshipped.ship

    assert shipped
    assert @ordernotyetshipped.shipped
  end

  test 'Can\'t Ship a Shipped Order' do
    shipped_nope = @ordershipped.ship

    assert_not shipped_nope
  end
end

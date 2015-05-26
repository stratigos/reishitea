require 'test_helper'

class OrderTest < ActiveSupport::TestCase

  setup do
    @order = Order.first
  end

  test 'Can Select an Order and its Comment' do
    assert @order
    assert_not_nil @order.comment
  end

  # Tests Order::ship by setting created_at 4 hours in the past (3 hours
  #  is needed for shipping to process and take place, its a pretend business
  #  rule).
  # Asserts that Order::ship returns TRUE for an instance with the right
  #  conditions, and that the Order.shipped value is updated. 
  test 'Can Ship an Order' do
    @order.created_at = 4.hours.ago

    shipped = @order.ship

    assert shipped
    assert @order.shipped
  end
end

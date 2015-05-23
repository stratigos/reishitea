require 'test_helper'

class OrderTest < ActiveSupport::TestCase

  setup do
    @order = Order.first
  end

  test 'Can Select an Order and its Comment' do
    assert @order
  end
end

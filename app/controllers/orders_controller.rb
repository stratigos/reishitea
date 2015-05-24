class OrdersController < ApplicationController
  def index
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)

    if @order.save
      redirect_to orders_index_path
    else
      render 'new'
    end
  end

  private

  def order_params
    params.require(:order).permit(:name, :street, :city, :state, :postal, :country, :quantity)
  end
end

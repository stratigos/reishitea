class OrdersController < ApplicationController

  # Loads the page of Orders and related information.
  def index
  end

  # Action to allow user to place a new Order. Allows query params for
  #  `name` and /or `quantity`.
  def new
    @order = Order.new

    if params[:name] && !params[:name].empty?
      @order.name = params[:name]
    end

    if params[:quantity] && !params[:quantity].empty?
      @order.quantity = params[:quantity]
    end
  end

  # Action to create a new Order.
  def create
    @order = Order.new(order_params)

    if @order.save
      redirect_to orders_root_path
    else
      render 'new'
    end
  end

  private

  def order_params
    params.require(:order).permit(:name, :street, :city, :state, :postal, :country, :quantity)
  end
end

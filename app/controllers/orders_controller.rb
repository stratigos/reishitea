class OrdersController < ApplicationController

  # Loads the page of Orders and related information.
  def index
    @recent_orders         = Order.recent.all
    @today_order_count     = Order.today.sum('quantity')
    @today_shipped_count   = Order.today.shipped.sum('quantity')
    @alltime_order_count   = Order.sum('quantity')
    @alltime_shipped_count = Order.shipped.sum('quantity')
  end

  # Action to allow user to place a new Order. Allows query params for
  #  `name` and /or `quantity`.
  def new
    @order = Order.new
    @order.build_comment

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
      flash[:notice] = 'Order succesfully submitted!'
      redirect_to orders_root_path
    else
      render 'new'
    end
  end

  private

  def order_params
    params.require(:order).permit(:name, :street, :city, :state, :postal, :country, :quantity, comment_attributes: [:body])
  end
end

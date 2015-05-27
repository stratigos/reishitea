###############################################################################
# Tasks for emulating ordering and shipping activity. Orders can be made, and
#  shipments of existing orders can be performed, both of which can be viewed
#  updating in real time from /orders. A third task allows for looping through
#  n-many Orders and shipments.
# Tasks make use of callback functions to perform creation / shipping, in 
#  order to facilitate sleeping for a few seconds in between orders (calling
#  Rake::TASK['...'].invoke results in hanging threads). 
###############################################################################
namespace :buynship do

  desc "Emulate a single customer order."
  task order: :environment do
    create_random_order
  end

  desc "Checks if any Orders are ready to be shipped, and ships them."
  task ship: :environment do
    ship_orders
  end

  desc "Loops n-many times, making Orders and shipping those that are ready."
  task emulate: :environment do
    # Accept user input for number of loops (Orders) to make. 
    #  Suggested: about 10-15 loops/Orders.
    puts 'Watch the /orders page for real time updates!'
    puts ''
    puts 'Please enter an integer value for the number of Orders to make: '
    puts '> '

    num_loops = STDIN.gets.chomp

    # Check if user entered an integer
    if /\d+/.match num_loops.to_s
      num_loops = num_loops.to_i
    end

    # Create randomish value for number of loops if user input is no good.
    if !num_loops.is_a? Numeric
      num_loops = rand(5..20)
      puts 'Non numeric input detected, making ' + num_loops.to_s + " Orders and shipment attempts.\n\n"
    else
      puts 'Making ' + num_loops.to_s + " Orders and shipment attempts.\n\n"
    end

    num_loops.times do
      puts 'Making an Order, and shipping...'
      create_random_order
      ship_orders
      sleep(rand(1..5))
    end

    puts "\nDont forget your daily dose of Reishi tea!\n"
  end

  # Callback function to create a new Order, and thus publish an event to
  #  Pusher (so real time updates can be viewed on the /orders page)
  def create_random_order
    # Generating some varying values based on current timestamp
    fan_num   = Time.now.to_i.to_s
    st_num    = fan_num.last(3)
    quant_num = fan_num.last(1)

    # Creating a new Order should send an event to a Pusher channel, to which
    #  the user facing app at /orders is subscribed, resulting in realtime 
    #  updates made visible on the page.
    order = Order.create({ :name => 'Reishi Fan #' + fan_num, :street => st_num + ' Someplace St',
                           :city => 'New York City', :state => 'New York', :postal => '11237', :country => 'USA',
                           :quantity => quant_num })

    puts 'Order ' + order.id.to_s + ' created.'
  end

  # Callback function to ship all 'processed' Orders. 
  def ship_orders
    ready_orders = Order.ready_for_shipping.all

    if !ready_orders.empty?
      puts 'Orders to ship: ' + ready_orders.count.to_s
      ready_orders.each do |order|
        order.ship
      end
    else
      puts 'No orders ready for shipping. Check back in 10 seconds.'
    end
  end

end

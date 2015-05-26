###############################################################################
# Tasks for emulating ordering and shipping activity. Orders can be made, and
#  shipments of existing orders can be performed, both of which can be viewed
#  updating in real time from /orders. 
###############################################################################
namespace :buynship do

  desc "Emulate a single customer order."
  task order: :environment do
    # Generating some varying values based on current timestamp
    fan_num   = Time.now.to_i.to_s
    st_num    = fan_num.last(3)#[-3, 3]
    quant_num = fan_num.last(1)#[-1, 1]

    # Creating a new Order should send an event to a Pusher channel, to which
    #  the user facing app at /orders is subscribed, resulting in realtime 
    #  updates made visible on the page.
    order = Order.create({ :name => 'Reishi Fan #' + fan_num, :street => st_num + ' Someplace St',
                           :city => 'New York City', :state => 'New York', :postal => '11237', :country => 'USA',
                           :quantity => quant_num })
  end

  desc "Checks if any orders are ready to be shipped, and ships them."
  task ship: :environment do
    puts 'Shipping stuff... shipping stuff...'
  end

end
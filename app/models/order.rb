###############################################################################
# Datatype to represent a customer's info and quantity of teas ordered.
#
# The shipping of Orders is handled via the ship() function. Orders need about
#  ten seconds to process, and then are able to be shipped.
# @see ./bin/rake buynship:ship
#
# The send_pusher callback sends the order placement event to Pusher.
#  @see https://pusher.com/
#  @todo Refactor the process in Order.send_pusher() into a concern / module.
###############################################################################
class Order < ActiveRecord::Base

  # String literals to describe Pusher events.
  PUSHER_EVENT_ORDER_RECIEVED = 'order_recieved'
  PUSHER_EVENT_ORDER_SHIPPED  = 'order_shipped'

  has_one :comment, dependent: :destroy, inverse_of: :order

  default_scope ->{ order(created_at: :desc) }
  scope :today, ->{ where('created_at >= ?', 1.day.ago) }
  scope :recent, ->{ today.limit(5) }
  scope :shipped, ->{ where('shipped = ?', true) }
  scope :ready_for_shipping, ->{ where('shipped = ?', false).where('created_at <= ?', 10.seconds.ago) }

  after_create :send_pusher

  validates_associated :comment
  validates :name, :street, :city, :state, :country, :postal, :quantity, presence: true
  validates :name, :city, :state, :country, length: { in: 2..50 }
  validates :street,   length: { in: 3..100 }
  validates :quantity, numericality: { only_integer: true, greater_than: 0, less_than: 101 }
  validates_format_of :postal, :with => /\d{5}(-\d{4})?/, :message => 'Invalid Postal Code'

  # 'Ships' the Order to the customer by flicking the on-button. A callback is
  #   made to the application Pusher account to send the shipment event to the
  #   appropriate channel. 
  # Imaginary business rule states it takes about ten seconds to process and ship
  #  each order.
  # @see lib/tasks/buynship.rake (./bin/rake buynship:ship)
  # @return Boolean
  #   TRUE if succesfully shipped,
  #   FALSE if Order already shipped or is not ten seconds old.
  def ship
    if (!self.shipped) && (self.created_at <= 10.seconds.ago)
      self.shipped = 1
      self.save
      send_pusher_shipment
      return true
    end

    false
  end

  private

  # Sends an event to Pusher account that a new Order has been made.
  # This could be refactored into a separate concern (which would include
  #  the CONST for event name).
  # Better control over this event hook can be applied by configuring this
  #  application to ignore callbacks unless such configuration is switched
  #  on (i.e., default off, turn on for specific tests, or for dev/prod
  #  environments). See http://railsguides.net/skip-callbacks-in-tests/.
  def send_pusher
    require 'pusher'

    Pusher.url = Rails.configuration.x.pusher.url

    Pusher[Rails.configuration.x.pusher.channel].trigger(
      PUSHER_EVENT_ORDER_RECIEVED,
      { order: self.to_json(:only => [ :name, :city, :country, :quantity ]) }
    )

    true
  end

  # Sends an event to Pusher account that an Order has been shipped. 
  # @see Order::send_pusher (refactor into seperate concern)
  def send_pusher_shipment
    require 'pusher'

    Pusher.url = Rails.configuration.x.pusher.url

    Pusher[Rails.configuration.x.pusher.channel].trigger(
      PUSHER_EVENT_ORDER_SHIPPED,
      { order: self.to_json(:only => :quantity ) }
    )

    true
  end

end

###############################################################################
# Datatype to represent a customer's info and quantity of teas ordered.
#
# The shipping of Orders is represented with the `shipped()` scope, which 
#  essentially implies that all Orders are shipped within 3 hours of 
#  placement of the Order.
#
# The send_pusher callback sends the order placement event to Pusher.
#  @see https://pusher.com/
#  @todo Refactor the process in Order.send_pusher() into a concern / module.
###############################################################################
class Order < ActiveRecord::Base

  # String literal to describe Pusher event.
  PUSHER_EVENT_ORDER_RECIEVED = 'order_recieved'

  has_one :comment, dependent: :destroy, inverse_of: :order

  default_scope ->{ order(created_at: :desc) }
  scope :today, ->{ where('created_at >= ?', 1.day.ago) }
  scope :recent, ->{ today.limit(5) }
  scope :shipped, ->{ today.where('created_at <= ?', 3.hours.ago) }

  after_create :send_pusher

  validates_associated :comment
  validates :name, :street, :city, :state, :country, :postal, :quantity, presence: true
  validates :name, :city, :state, :country, length: { in: 2..50 }
  validates :street,   length: { in: 3..100 }
  validates :quantity, numericality: { only_integer: true, greater_than: 0, less_than: 101 }
  validates_format_of :postal, :with => /\d{5}(-\d{4})?/, :message => 'Invalid Postal Code'

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

end

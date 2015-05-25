class Order < ActiveRecord::Base

  # String literal to describe Pusher event.
  # @see https://pusher.com/
  PUSHER_EVENT_ORDER_RECIEVED = 'order_recieved'

  has_one :comment, dependent: :destroy, inverse_of: :order

  after_create :send_pusher

  validates_associated :comment
  validates :name, :street, :city, :state, :country, :postal, :quantity, presence: true
  validates :name, :city, :state, :country, length: { in: 3..50 }
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
      { message: 'New Order ' + self.id.to_s }
    )

    true
  end

end

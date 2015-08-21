# Configuration for the 'Pusher' pub/sub service. 
# @see app/models/order.rb
# @see https://pusher.com/tutorials
pusher_config = Rails.application.config_for(:pusher)

pusher_config.each do |param, value|
  Rails.application.config.x.pusher[param] = value
end

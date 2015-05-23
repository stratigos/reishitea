class Order < ActiveRecord::Base
  has_one :comment, dependent: :destroy, inverse_of: :order

  validates_associated :comment
  validates :name, :street, :city, :state, :country, :postal, :quantity, presence: true
  validates :name, :city, :state, :country, length: { in: 3..50 }
  validates :street,   length: { in: 3..100 }
  validates :quantity, numericality: { only_integer: true, greater_than: 0, less_than: 101 }
  validates_format_of :postal, :with => /\d{5}(-\d{4})?/, :message => 'Invalid Postal Code'

end

class Comment < ActiveRecord::Base
  belongs_to :order, inverse_of: :comment

  validates :order_id, presence: true
  validates :body,     length: { in: 3..255 }
end

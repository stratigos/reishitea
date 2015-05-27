class Comment < ActiveRecord::Base
  belongs_to :order, inverse_of: :comment

  validates :body, length: { in: 3..255 }
end

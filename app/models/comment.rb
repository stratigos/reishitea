class Comment < ActiveRecord::Base
  belongs_to :order, inverse_of: :comment

  default_scope ->{ order(created_at: :desc) }
  scope :recent, -> { limit(3) }

  validates :body, length: { in: 3..255 }
end

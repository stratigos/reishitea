require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  setup do
    @comment = Comment.first
  end

  test 'Can Select a Comment' do
    assert @comment
  end
end

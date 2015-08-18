require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  setup do
    @new_comment = Comment.new
  end

  test 'Can Select a Comment' do
    assert @one
  end

  test 'Can Select a Comment\'s Order' do
    assert @one.order
  end

  # Test validations. Mainly concerned with enforcing business logic or 
  #  critical features.
  test 'Body Length isn\'t too Long' do
    @new_comment.body = (0...257).map { ('a'..'z').to_a[rand(26)] }.join
    @new_comment.wont_be :valid?
    @new_comment.errors[:body].must_equal ['is too long (maximum is 255 characters)']
  end

  test 'Body Length isn\'t too Short' do
    @new_comment.body = 'fu'
    @new_comment.wont_be :valid?
    @new_comment.errors[:body].must_equal ['is too short (minimum is 3 characters)']
  end
end

require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup
    clean_couch
  end

  test "#create" do
    new_comment = Comment.create(:body => 'comment')
    assert_not_nil new_comment.id

    comment = Comment.get(new_comment.id)
    assert_equal 'comment', comment.body
  end

  test '#create with errors' do
    comment = Comment.create
    assert_nil comment.id
    assert_equal [:body], comment.errors.keys
  end
  
end

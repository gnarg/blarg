require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  def setup
    clean_couch
  end

  test "#create saves the given comment for a post" do
    test_post = Post.create(:slug => 'test-post' )
    post :create, :post_id => test_post.id, :comment => {:author => 'author', :comment => 'comment', :url => 'url'}
    assert_equal 'test-post', assigns(:post).slug
    assert_equal 'author', assigns(:comment).author
    assert_equal 'url', assigns(:comment).url
    assert_equal 'comment', assigns(:comment).comment
  end
end

require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  def setup
    clean_couch
  end

  test "#create saves the given comment for a post" do
    test_post = create_post(:slug => 'test-post' )

    post :create, :post_id => test_post.id, :comment => {:author => 'author', :body => 'comment', :url => 'url'}

    assert_response :success

    assert_equal 'test-post', assigns(:post).slug
    assert_equal 'author', assigns(:comment).author
    assert_equal 'url', assigns(:comment).url
    assert_equal 'comment', assigns(:comment).body
  end

   test "#create returns a 403 status on validation errors" do
    test_post = create_post(:slug => 'test-post-with-validation-errors' )

    post :create, :post_id => test_post.id, :comment => {:author => 'author', :url => 'url'}

    assert_response 403
    assert_equal( "{\"body\":[\"Body must not be blank\"]}", @response.body )
    assert_equal 'test-post-with-validation-errors', assigns(:post).slug
    assert_equal 'author', assigns(:comment).author
    assert_equal 'url', assigns(:comment).url
    assert_equal nil, assigns(:comment).body
    assert_equal( { :body => ["Body must not be blank"] }, assigns(:comment).errors.to_hash )
  end
end

require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  def setup
    clean_couch
  end
  
  test "#show gets the post by slug" do
    post = Post.create(:slug => 'test-post')
    get :show, :id => 'test-post'
    assert_equal post.id, assigns(:post).id
  end
  
  test "#edit gets the post by slug" do
    post = Post.create(:slug => 'test-post')
    get :edit, :id => 'test-post'
    assert_equal post.id, assigns(:post).id
  end
end

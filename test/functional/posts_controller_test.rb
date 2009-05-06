require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  test "#show gets the post by slug" do
    post = Post.create(:slug => 'test-post')
    get :show, :id => 'test-post'
    assert_equal post.id, assigns(:post).id
  end
end

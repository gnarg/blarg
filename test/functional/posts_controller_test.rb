require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  def setup
    clean_couch
  end
  
  test "gets recent posts" do
    post = Post.create(:slug => 'post1')
    
    get :index
    
    assert assigns(:recent_posts).include?(post)
  end
  
  test "gets a list of all tags" do
    post_foo = Post.create(:tags => ['foo'])
    post_bar = Post.create(:tags => ['bar'])
    
    get :index
    
    assert assigns(:all_tags).include?('foo')
    assert assigns(:all_tags).include?('bar')    
  end
  
  test "#index with no tags shows all posts" do
    post1 = Post.create(:slug => 'post1')
    post2 = Post.create(:slug => 'post2') 
    
    get :index
    
    assert assigns(:posts).include?(post1)
    assert assigns(:posts).include?(post2)    
  end
  
  test "#index with tags shows all posts with all given tags" do
    post_foo = Post.create(:tags => ['foo'])
    post_bar = Post.create(:tags => ['bar'])
    post_foo_bar = Post.create(:tags => ['foo', 'bar'])
    
    get :index, :tags => ['foo', 'bar']
    
    assert assigns(:posts).include?(post_foo_bar)
    assert !assigns(:posts).include?(post_foo)
    assert !assigns(:posts).include?(post_bar)    
  end
  
  # test "#index shows posts ordered by create_date"
  
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
  
  test "#update updates the specified post on success" do
    post = Post.create(:slug => 'test-post', :title => 'old-title')
    put :update, :id => 'test-post', :post => {:slug => 'test-post', :title => 'new-title' }
    assert_equal 'new-title', assigns(:post).title
    assert_redirected_to :action => 'show', :id => 'test-post'
  end  
  
  test "#new renders a form with a new post" do
    get :new
    assert assigns(:post).new_document?
  end
  
  test "#create saves the given post data as a new post" do
    post :create, :post => {:slug => 'test-post', :title => 'test post'}
    assert_redirected_to :action => 'show', :id => 'test-post'
    assert_equal 'test post', assigns(:post).title
  end
end

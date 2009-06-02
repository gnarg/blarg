require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    clean_couch
  end
  
  test "#comments returns the associated comments" do
    post = create_post(:title => 'new post')
    comment1 = Comment.create(:post_id => post.id, :body => 'comment')
    comment2 = Comment.create(:post_id => post.id, :body => 'comment')
    
    post_comments = post.comments
    
    assert post_comments.include?(comment1)
    assert post_comments.include?(comment2)    
  end
  
  test ".get_by_slug returns the post with given slug" do
    saved_post = create_post(:slug => 'test-slug')
    found_post = Post.get_by_slug('test-slug')
    
    assert_equal saved_post, found_post
  end
  
  test ".get_by_tags returns all posts with all given tags" do
    post_foo = create_post(:tags => ['foo'])
    post_bar = create_post(:tags => ['bar'])
    post_foo_bar = create_post(:tags => ['foo', 'bar'])
    
    posts = Post.get_by_tags('foo', 'bar')
    
    assert posts.include?(post_foo_bar)
    assert !posts.include?(post_foo)
    assert !posts.include?(post_bar)
  end
  
  test ".get_by_tags returns all posts if no tags are given" do
    post_foo = create_post(:tags => ['foo'])
    post_bar = create_post(:tags => ['bar'])
    post_foo_bar = create_post(:tags => ['foo', 'bar'])
    
    posts = Post.get_by_tags
    
    assert posts.include?(post_foo_bar)
    assert posts.include?(post_foo)
    assert posts.include?(post_bar)
  end
  
  test ".get_all_tags returns unique list of all tags" do
    post_foo = create_post(:tags => ['foo'])
    post_bar = create_post(:tags => ['bar'])
    post_foo_bar = create_post(:tags => ['foo', 'bar'])
    post_foo_baz = create_post(:tags => ['foo', 'baz'])
    
    tags = Post.get_all_tags
    
    assert_equal 3, tags.size
    assert tags.include?('foo')
    assert tags.include?('bar')
    assert tags.include?('baz')        
  end
end

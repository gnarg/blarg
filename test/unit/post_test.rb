require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    clean_couch
  end
  
  test "#comments returns the associated comments" do
    post = Post.create(:title => 'new post')
    comment1 = Comment.create(:post_id => post.id)
    comment2 = Comment.create(:post_id => post.id)
    
    post_comments = post.comments
    
    assert post_comments.include?(comment1)
    assert post_comments.include?(comment2)    
  end
  
  test ".get_by_slug returns the post with given slug" do
    saved_post = Post.create(:slug => 'test-slug')
    found_post = Post.get_by_slug('test-slug')
    
    assert_equal saved_post, found_post
  end
end

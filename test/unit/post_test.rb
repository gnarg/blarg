require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test "#comments returns the associated comments" do
    post = Post.create(:title => 'new post')
    comment1 = Comment.create(:post_id => post.id)
    comment2 = Comment.create(:post_id => post.id)
    
    post_comments = post.comments
    
    assert post_comments.include?(comment1)
    assert post_comments.include?(comment2)    
  end
end

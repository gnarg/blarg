require 'test_helper'

class PostCommentTest < ActionController::IntegrationTest

  test "Posts have a comment form" do
    post = Post.create( :slug => 'test-post-comments', :body => '<p>one</p><p>two</p><p>three</p><p>four</p><p>five</p>' )
    post.save
    visit '/posts/' + post.slug
                                    
    fill_in "comment_author", :with => "testy"
    fill_in "comment_url", :with => "slackworks.com"
    fill_in "comment_body", :with => "comment"
    click_button "Post comment"    
  end
end

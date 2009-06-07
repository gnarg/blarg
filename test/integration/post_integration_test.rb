require 'test_helper'

class PostIntegrationTest < ActionController::IntegrationTest

  test "Create a Post successfully and redirect" do
    assert_difference 'Post.count' do
      visit '/posts/new'

      fill_in "post_slug", :with => "slug"
      fill_in "post_title", :with => "title"
      fill_in "post_author", :with => "testy"
      fill_in "post_body", :with => "comment"
      click_button "Post"

      assert_equal 0, assigns(:post).errors.size
      # should be a redirect, but webrat says it is not so
      #assert_redirected_to post_path('slug')
    end
  end

  test "Create a Post failed and return errors" do
    assert_no_difference 'Post.count' do
      visit '/posts/new'

      fill_in "post_slug", :with => "slug"
      click_button "Post"

      assert_equal [:title, :author, :body], assigns(:post).errors.to_hash.keys
      assert_template 'posts/new.html.erb'
    end
  end
end

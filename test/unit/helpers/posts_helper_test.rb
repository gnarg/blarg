require 'test_helper'

class PostsHelperTest < ActionView::TestCase
  def setup
    @controller = TestController.new
  end

  test "#render_slim_body returns a limited post body" do
    post = Post.create( :slug => 'test-post-helper', :body => '<p>one</p><p>two</p><p>three</p><p>four</p><p>five</p>' )
    post.save
    assert_equal(
      "<p>one</p><p>two</p><p>three</p><p>four</p><p><a href=\"/posts/#{post.slug}\">&#8230; more</a></p>", render_slim_body( post ) )
  end

  test "#render_redcloth transforms redcloth into html" do
    assert_equal( '<h2>header</h2>', render_redcloth('h2. header') )
  end

  test "#render_body will render using render_slim_body" do
    post = Post.create( :slug => 'test-post-helper', :body => '<p>one</p><p>two</p><p>three</p><p>four</p><p>five</p>' )
    post.save
    assert_equal(
      "<p>one</p><p>two</p><p>three</p><p>four</p><p><a href=\"/posts/#{post.slug}\">&#8230; more</a></p>", render_body( post, true ) )

  end

  test "#render_body will render everything in post body" do
    post = Post.create( :slug => 'test-post-helper', :body => '<p>one</p><p>two</p><p>three</p><p>four</p><p>five</p>' )
    post.save
    assert_equal(
      "<p>one</p><p>two</p><p>three</p><p>four</p><p>five</p>", render_body( post ) )

  end

end

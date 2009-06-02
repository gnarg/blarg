class PostsController < ApplicationController
  before_filter :marshal_params
  before_filter :get_post_by_slug, :only => [:show, :edit, :update]
  # before :basic_authentication, :only => [ :new, :create, :edit, :update ]

  def index
    @posts = Post.get_by_tags(*@tags).reverse
    
    # raise NotFound if @posts.empty?

    # if content_type == :xml
    #   @base_host = request.protocol + request.host
    #   if @tags.any?
    #     @base_url = @base_host + '/tags/' + @tags.join('/')
    #   else
    #     @base_url = @base_host + '/posts'
    #   end
    # end

    # raise @tags.inspect
  end

  def show
    params.delete(:format)
    if @post
      @comments = @post.comments
    else
      @comments = false
    end
  end

  def new
    @post = Post.new
    @post.created_at = Time.now
    @post.updated_at = Time.now
  end

  def edit
    @post.updated_at = Time.now
  end

  def create
    @post = Post.new(params[:post])
    if @post.save
      redirect_to post_path(@post.slug)
    else
      # TODO: add error messages to flash
      render :template => 'posts/new'
    end
  end

  def update
    @post.merge(params[:post])
    if @post.save
      redirect_to post_path(@post.slug)
    else
      # TODO: add error messages to flash
      render :template => 'posts/edit', :id => @post.slug
    end
  end

protected
  
  def get_post_by_slug
    @post = Post.get_by_slug(params[:id])
  end

  def marshal_params
    @tags = params[:tags]

    if params[:post]
      params[:post][:created_at] = Time.parse(params[:post][:created_at]).xmlschema rescue Time.now
      params[:post][:updated_at] = Time.parse(params[:post][:updated_at]).xmlschema rescue Time.now    
    end
  end
end

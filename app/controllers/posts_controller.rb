class PostsController < ApplicationController
  before_filter :marshal_params
  # before :basic_authentication, :only => [ :new, :create, :edit, :update ]

  def index
    provides :xml
    @posts = Post.find_by_tags(@tags)
    raise NotFound if @posts.empty?

    if content_type == :xml
      @base_host = request.protocol + request.host
      if @tags.any?
        @base_url = @base_host + '/tags/' + @tags.join('/')
      else
        @base_url = @base_host + '/posts'
      end
    end

    render
  end

  def show
    @post = Post.find_by_id(params[:id])
    params.delete(:format)
    render
  end

  def new
    @post = Post.new
    @post.created_at = Time.now
    @post.updated_at = Time.now
    render
  end

  def edit
    @post = Post.find_by_id(params[:id])
    @post.updated_at = Time.now
    render
  end

  def create
    doc = CouchObject::Document.new(params[:post])
    @post = Post.new(doc)
    @post.document_id = params[:post][:document_id]

    response = @post.save
    if response['ok']
      redirect "/posts/#{@post.document_id}"
    else
      raise response.inspect
      # TODO: add error messages to flash
      render :template => 'posts/new'
    end
  end

  def update
    @post = Post.find_by_id(params[:id])

    response = @post.update_attributes(params[:post])
    if response['ok']
      redirect "/posts/#{@post.document_id}"
    else
      raise response.inspect
      # TODO: add error messages to flash
      render :template => 'posts/edit', :id => @post.document_id
    end
  end

  protected

  def marshal_params
    @tags = params[:tags].split('/') rescue []

    if params[:post]
      params[:post][:created_at] = Time.parse(params[:post][:created_at]).xmlschema rescue Time.now
      params[:post][:updated_at] = Time.parse(params[:post][:updated_at]).xmlschema rescue Time.now    
      params[:post][:tags] = params[:post][:tags].split(' ')
    end
  end
end

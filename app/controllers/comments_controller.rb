class CommentsController < ApplicationController
  before_filter :get_post

  def new
    @comment = Comment.new
    @comment.created_at = Time.now
    @comment.updated_at = Time.now
  end

  def edit
    @comment.updated_at = Time.now
  end

  def create
    @comment = Comment.new(params[:comment])
    if @comment.body.instance_of? Array
      @comment.body = @comment.body.join( ' ' )      
    end
    respond_to do |format|      

      format.js  do
        if @comment.save
          render :partial => 'comments/comment', :locals => { :comment => @comment}, :layout => false
        end  
      end
    end
  end

  def update
    @comment.replace(params[:comment])
    if @comment.save
      redirect_to post_path(@comment.slug)
    else
      # TODO: add error messages to flash
      render :template => 'posts/edit', :id => @comment.slug
    end
  end

  protected

  def get_post
    @post = Post.get(params[:post_id])
  end

  def marshal_params
    if params[:post]
      params[:post][:created_at] = Time.parse(params[:post][:created_at]).xmlschema rescue Time.now
      params[:post][:updated_at] = Time.parse(params[:post][:updated_at]).xmlschema rescue Time.now
    end
  end
end

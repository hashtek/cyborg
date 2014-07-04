require 'redcarpet'

class PostsController < ApplicationController

  helper_method :markdown

  public
  def markdown(text)
  	renderer = Redcarpet::Render::HTML.new(no_links: false, hard_wrap: true)
	mkdown = Redcarpet::Markdown.new(renderer, extensions = {})
	mkdown.render(text)
  end


  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.order('timestamp DESC')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
      format.atom
    end
  end

  def error
    @message = "Page not found"
    respond_to do |format|
      format.html
    end
  end

  def search
    @posts = Post.where("title LIKE '%#{params[:query]}%'")
    respond_to do |format|
      format.html
    end
  end

  def archives
    @posts = Post.where("timestamp LIKE '%#{params[:yymm]}%'")
    respond_to do |format|
      format.html
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new
    @post.author = current_user.email
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end
end

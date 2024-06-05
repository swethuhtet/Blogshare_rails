class BlogsController < ApplicationController
  before_action :authenticate_user! 

  def index
    blogs = Blog.all
    render json:blogs 
  end

  def show
    blog = Blog.includes(:category).find(params[:id])
    render json:blog.to_json(include: :category)
  end

  def create
    blog = Blog.new(blog_params)
    if blog.save
      render json: blog
    else
      render json: {error: 'Unable to add blog'}, status: 400
    end
  end

  def update
    blog = Blog.find(params[:id])
    if blog
        blog.update(blog_params)
        render json: blog, status: 200
    else
        render json: {error: 'Unable to update blog'}, status: 400
    end
  end

  def destroy
    blog = Blog.find(params[:id])
    if blog
      blog.destroy
      render json: blog,status: 200
    else
      render json: {error: 'Unable to delete blog'}, status: 400
    end
  end

  private
  def blog_params
    params.permit(:title,:body,:category_id)
  end

  protected 
    def authenticate_user!
      unless user_signed_in?
        render json: { error: 'You need to sign in or sign up before continuing.' }, status: :unauthorized
      end
    end
end

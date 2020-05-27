require 'will_paginate/array'

class StaticPagesController < ApplicationController
  

  def home
    @recent_posts = Micropost.where(created_at: (Time.now.midnight - 30.day)..(Time.now.midnight + 1.day)).order('created_at DESC').paginate(page: params[:page])
    @user_ids = Micropost.order('created_at DESC').pluck(:user_id).uniq
    @most_viewed_posts = Micropost.order('view DESC').take(5)
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
    render 'static_pages/home'
  end

  def filter
    @user_ids = Micropost.order('created_at DESC').pluck(:user_id).uniq
    @most_viewed_posts = Micropost.order('view DESC').take(5)
    if (params[:topic].nil?)
      @recent_posts = Micropost.where(created_at: (Time.now.midnight - 30.day)..(Time.now.midnight + 1.day)).order('created_at DESC').paginate(page: params[:page])
    else
      @recent_posts = Micropost.where(topic: params[:topic]).order('created_at DESC').paginate(page: params[:page])
      @test = (params[:topic])
    end
    render 'static_pages/home'
  end

  def filtercontent
    @user_ids = Micropost.order('created_at DESC').pluck(:user_id).uniq
    @most_viewed_posts = Micropost.order('view DESC').take(5)
    if (params[:content].nil?)
      @recent_posts = Micropost.where(created_at: (Time.now.midnight - 30.day)..(Time.now.midnight + 1.day)).order('created_at DESC').paginate(page: params[:page])
    else
      @recent_posts = Micropost.where("content LIKE ?", "%" + params[:content] + "%").order('created_at DESC').paginate(page: params[:page])
    end
    render 'static_pages/home'
  end

  def help
  end

  def about
  end

  def contact
  end

end

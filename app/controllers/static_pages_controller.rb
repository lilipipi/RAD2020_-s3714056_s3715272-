require 'will_paginate/array'

class StaticPagesController < ApplicationController
  

  
  def home
    @recent_posts = Micropost.where(created_at: (Time.now.midnight - 30.day)..(Time.now.midnight + 1.day)).paginate(page: params[:page])
    @user_ids = Micropost.pluck(:user_id).uniq
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def filter
    @user_ids = Micropost.pluck(:user_id).uniq
    if (params[:topic].nil?)
      @recent_posts = Micropost.where(created_at: (Time.now.midnight - 30.day)..(Time.now.midnight + 1.day)).paginate(page: params[:page])
    else
      @recent_posts = Micropost.where(topic: params[:topic]).paginate(page: params[:page])
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

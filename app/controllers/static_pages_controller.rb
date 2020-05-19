class StaticPagesController < ApplicationController

  def home
    @recent_posts = Micropost.where(created_at: (Time.now.midnight - 30.day)..(Time.now.midnight + 1.day)).paginate(page: params[:page])
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end

end

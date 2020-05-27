class ApplicationController < ActionController::Base
  protect_from_forgery with:  :exception
  include SessionsHelper
  $topic = ["topic 1", "topic 2", "topic 3", "topic 4", "topic 5"]
  private

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end

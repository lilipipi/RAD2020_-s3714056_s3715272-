class MicropostsController < ApplicationController
    before_action :logged_in_user, only: [:create, :destroy]
    before_action :correct_user, only: :destroy

    

    def show
        @micropost = Micropost.find(params[:id])
        @user = @micropost.user
        @views = @micropost.view
        @views +=1
        @micropost.update(view: @views)
    end
    
    def create
        @micropost = current_user.microposts.build(micropost_params)
        if @micropost.save
            flash[:success] = "Micropost created!"
            redirect_to root_url
        else
            @recent_posts = Micropost.where(created_at: (Time.now.midnight - 30.day)..(Time.now.midnight + 1.day)).paginate(page: params[:page])
            @feed_items = current_user.feed.paginate(page: params[:page])
            render 'static_pages/home'
        end
        @micropost.update(view: 0)
    end

    def destroy
        @micropost.destroy
        flash[:success] = "Micropost deleted"
        redirect_to request.referrer || root_url
    end

    private

        def micropost_params
            params.require(:micropost).permit(:content, :topic, :title)
        end

        def correct_user
            @micropost = current_user.microposts.find_by(id: params[:id])
            redirect_to root_url if @micropost.nil?
        end
end

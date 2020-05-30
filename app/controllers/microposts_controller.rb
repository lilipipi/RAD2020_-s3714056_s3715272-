class MicropostsController < ApplicationController
    before_action :logged_in_user, only: [:show, :create, :destroy, :new]
    before_action :correct_user, only: :destroy

    
    

    def show
        @micropost = Micropost.find(params[:id])
        @user = @micropost.user
        @views = @micropost.view
        @views +=1
        @micropost.update(view: @views)
        @user_ids = Micropost.order('created_at DESC').pluck(:user_id).uniq
        @most_viewed_posts = Micropost.order('view DESC').take(5)
    end

    def new        
        @user = current_user
        @micropost = current_user.microposts.build       
    end
    
    def create
        @micropost = current_user.microposts.build(micropost_params)
        @user = @micropost.user
        if @micropost.save
            flash[:success] = "Micropost created!"
            redirect_to root_url
        else
            render 'microposts/new'
        end
        @micropost.update(view: 0)
    end

    def destroy
        @micropost.destroy
        flash[:success] = "Micropost deleted"
        redirect_to root_url
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

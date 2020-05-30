class CommentsController < ApplicationController
    before_action :logged_in_user
    before_action :correct_user, only: :destroy

    def create
        @comment = @commentable.comments.new(comment_params)
        @comment.user_id = current_user.id
        @comment.micropost_id = @commentable.id
        @comment.save
        flash[:success] = "Your comment was successfully created"
        redirect_to @commentable
    end

    def destroy
        @comment = Comment.find(params[:id])
        @comment.destroy
        flash[:success] = "Comment deleted"
        redirect_to comments_path
    end

    private

        def comment_params
            params.require(:comment).permit(:body)
        end

        def correct_user
            @comment = Comment.find(params[:id])
            redirect_to root_url if User.find(@comment.user_id) != current_user
        end
end
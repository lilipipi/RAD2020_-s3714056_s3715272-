class Microposts::CommentsController < CommentsController
    before_action :set_commentable

    private

        def set_commentable
            @commentable = Micropost.find(params[:micropost_id])
        end
end
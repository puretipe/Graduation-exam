class CommentsController < ApplicationController
  before_action :require_login
  before_action :set_song

  def create
    @comment = @song.comments.build(comment_params)
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        format.turbo_stream
        format.html { redirect_to @song }
      else
      end
    end
  end

  def destroy
    @comment = @song.comments.find(params[:id])
    @comment.destroy if @comment.user == current_user
  end

  private

  def set_song
    @song = Song.find(params[:song_id])
  end

  def comment_params
    params.require(:comment).permit(:content).merge(song_id: params[:song_id])
  end
end

class SongsController < ApplicationController
  def index
    @songs = Song.all
  end

  def new
    @song = Song.new
    @focus_points = FocusPoint.all
  end

  def create
    @song = current_user.songs.new(song_params)
    if @song.embed_url.include?('youtube.com')
      @song.thumbnail_url = YoutubeService.get_thumbnail_url(@song.embed_url)
    elsif @song.embed_url.include?('nicovideo.jp')
      @song.thumbnail_url = NiconicoService.get_thumbnail_url(@song.embed_url)
    end
    if @song.save
      flash[:success] = '登録が完了しました'
      redirect_to songs_path
    else
      @focus_points = FocusPoint.all
      render :new
    end
  end

  private

  def song_params
    params.require(:song).permit(:title, :artist, :embed_url, :software_name, :description, :genre_name, :focus_point_id)
  end
end

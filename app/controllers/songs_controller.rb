class SongsController < ApplicationController
  before_action :require_login, only: [:new, :create, :my_songs, :edit, :update]

  def index
    @q = Song.ransack(params[:q])
    @songs = @q.result.includes(:genre, :focus_point, :evaluations)
    if params[:q] && params[:q][:s] && params[:q][:s].include?("_evaluations_count")
      sort_param = params[:q][:s]
      evaluation_type, order = sort_param.split(' ').first.split('_evaluations_count').first, sort_param.split.last
      @songs = @songs.sorted_by_evaluations(evaluation_type, order)
    else
      @songs = @songs.order(created_at: :desc)
    end
    @songs = @songs.page(params[:page])
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
    begin
      if @song.save
        flash[:success] = '投稿が完了しました'
        redirect_to songs_path
      else
        @focus_points = FocusPoint.all
        render :new
      end
    rescue ActiveRecord::RecordNotUnique
      flash.now[:danger] = '一つの動画は一回しか投稿できません。'
      @focus_points = FocusPoint.all
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @song = Song.find(params[:id])
  end

  def edit
    @song = Song.find(params[:id])
    @song.genre_name = @song.genre.name if @song.genre
    @focus_points = FocusPoint.all
    @genres = Genre.all
  end

  def update
    @song = Song.find(params[:id])
    @song.genre_name = song_params[:genre_name]
  
    if @song.update(song_params)
      flash[:success] = "楽曲情報を更新しました。"
      redirect_to song_path(@song)
    else
      @focus_points = FocusPoint.all
      @genres = Genre.all
      render :edit, status: :unprocessable_entity
    end
  end

  def my_songs
    @q = current_user.songs.ransack(params[:q])
    @songs = @q.result.includes(:genre, :focus_point, :evaluations)
    if params[:q] && params[:q][:s] && params[:q][:s].include?("_evaluations_count")
      sort_param = params[:q][:s]
      evaluation_type, order = sort_param.split(' ').first.split('_evaluations_count').first, sort_param.split.last
      @songs = @songs.sorted_by_evaluations(evaluation_type, order)
    else
      @songs = @songs.order(created_at: :desc)
    end
    @songs = @songs.page(params[:page])
  end

  private

  def song_params
    params.require(:song).permit(:title, :artist, :embed_url, :software_name, :description, :genre_name, :focus_point_id)
  end
end

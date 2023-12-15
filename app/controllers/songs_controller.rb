class SongsController < ApplicationController
  before_action :require_login, only: [:new, :create]

  def index
    @q = Song.ransack(params[:q])
    @songs = @q.result.includes(:genre, :focus_point, :evaluations).order(created_at: :desc).page(params[:page])
    if params[:q] && params[:q][:s]
      sort_param = params[:q][:s]
      if sort_param.include?("_evaluations_count")
        evaluation_type, order = sort_param.split('_evaluations_count ').first, 'desc'
        @songs = @songs.sorted_by_evaluations(evaluation_type, order)
      end
    end
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

  def my_songs
    @q = current_user.songs.ransack(params[:q])
    @songs = @q.result.includes(:genre, :focus_point, :evaluations).order(created_at: :desc).page(params[:page])

    if params[:q] && params[:q][:s]
      sort_param = params[:q][:s]
      if sort_param.include?("_evaluations_count")
        evaluation_type, order = sort_param.split('_evaluations_count ').first, 'desc'
        @songs = @songs.sorted_by_evaluations(evaluation_type, order)
      end
    end
  end

  private

  def song_params
    params.require(:song).permit(:title, :artist, :embed_url, :software_name, :description, :genre_name, :focus_point_id)
  end
end

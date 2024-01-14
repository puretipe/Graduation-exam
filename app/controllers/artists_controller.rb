class ArtistsController < ApplicationController
  before_action :set_artist, only: [:show, :songs, :follow, :unfollow]
  before_action :require_login, only: [:follow, :unfollow]

  def show
  end

  def songs
    load_songs(@artist.songs)
  end

  def follow
    current_user.following_relationships.create(followed_id: @artist.id)
  end

  def unfollow
    current_user.following_relationships.find_by(followed_id: @artist.id).destroy
  end

  private

  def set_artist
    @artist = User.find(params[:id])
  end

  def load_songs(songs)
    @q = songs.ransack(params[:q])
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
end

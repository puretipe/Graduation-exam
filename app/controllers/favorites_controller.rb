class FavoritesController < ApplicationController
  before_action :require_login

  def create
    @song = Song.find(params[:song_id])
    current_user.favorited_songs << @song
  end

  def destroy
    favorite = current_user.favorites.find_by(song_id: params[:song_id])
    @song = favorite.song
    favorite.destroy
  end
end

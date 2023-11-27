class AutocompletesController < ApplicationController
  def autocomplete
    query = params[:term]
    results = Song.joins(:genre).where('songs.title LIKE ? OR songs.artist LIKE ? OR songs.software_name LIKE ? OR genres.name LIKE ?', "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%")

    # 各楽曲に対して適切なフォーマットを選択
    formatted_results = results.map do |song|
      if song.title.include?(query)
        song.title
      elsif song.artist.include?(query)
        song.artist
      elsif song.software_name.include?(query)
        song.software_name
      else
        song.genre.name
      end
    end
  
    unique_results = formatted_results.uniq

    render json: unique_results
  end
end

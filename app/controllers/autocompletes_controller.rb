class AutocompletesController < ApplicationController
  def autocomplete
    query = params[:term].downcase
    results = Song.joins(:genre).where('lower(songs.title) LIKE ? OR lower(songs.artist) LIKE ? OR lower(songs.software_name) LIKE ? OR lower(genres.name) LIKE ?', "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%")

    filtered_results = results.select do |song|
      query.in?(song.title.downcase) || query.in?(song.artist.downcase) || query.in?(song.software_name.downcase) || query.in?(song.genre.name.downcase)
    end

    formatted_results = filtered_results.map do |song|
      if song.title.downcase.include?(query)
        song.title
      elsif song.artist.downcase.include?(query)
        song.artist
      elsif song.software_name.downcase.include?(query)
        song.software_name
      else
        song.genre.name
      end
    end

    render json: formatted_results.uniq
  end
end

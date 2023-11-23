class AutocompletesController < ApplicationController
  def autocomplete
    query = params[:term]
    # タイトル、アーティスト、ソフト名、ジャンルに基づいて検索するロジックを実装
    results = Song.where('title LIKE ? OR artist LIKE ? OR software_name LIKE ? OR genre_name LIKE ?', "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%")
    render json: results.map(&:title) # または必要に応じて他の属性
  end
end

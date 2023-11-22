class Song < ApplicationRecord
  belongs_to :user
  belongs_to :genre
  belongs_to :focus_point
  has_many :evaluations, dependent: :destroy
  attr_accessor :genre_name

  before_validation :set_genre, on: :create
  before_save :convert_to_embed_url
  validate :valid_embed_url
  validates :title, presence: true, length: { maximum: 255 }
  validates :artist, presence: true, length: { maximum: 255 }
  validates :embed_url, presence: true, length: { maximum: 255 }
  validates :software_name, presence: true, length: { maximum: 255 }

  def self.ransackable_attributes(auth_object = nil)
    %w[title artist software_name genre_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[evaluations focus_point genre user]
  end

  scope :sorted_by_evaluations, -> (evaluation_type, order) {
    subquery = Evaluation.where(evaluation_point: Evaluation.evaluation_points[evaluation_type.to_sym])
                         .select('song_id, COUNT(id) as evaluations_count')
                         .group('song_id')
  
    joins("INNER JOIN (#{subquery.to_sql}) as evals ON evals.song_id = songs.id")
      .select('songs.*, evals.evaluations_count')
      .order(Arel.sql("evals.evaluations_count #{order.upcase}"))
  }

  private

  def valid_embed_url
    return if embed_url.blank?
  
    youtube_regex = %r{\Ahttps?://(www\.youtube\.com/watch\?v=|www\.youtube\.com/embed/|youtu\.be/)[^/\s]+\z}
    niconico_regex = %r{\Ahttps?://(www\.nicovideo\.jp/watch/|embed\.nicovideo\.jp/watch/)[^/\s]+\z}
  
    unless embed_url =~ youtube_regex || embed_url =~ niconico_regex
      errors.add(:embed_url, "のフォーマットが正しくありません(動画再生画面のURLを入力して下さい)")
    end
  end

  def convert_to_embed_url
    if embed_url =~ %r{\Ahttps?://www\.youtube\.com/watch\?v=([^&]+)}
      self.embed_url = "https://www.youtube.com/embed/#{$1}"
    elsif embed_url =~ %r{\Ahttps?://www\.nicovideo\.jp/watch/([^/?]+)}
      self.embed_url = "https://embed.nicovideo.jp/watch/#{$1}"
    end
  end

  def set_genre
    return if genre_name.blank?
    genre = Genre.find_or_create_by(name: genre_name)
    self.genre_id = genre.id
  end
end

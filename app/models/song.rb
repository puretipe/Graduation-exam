class Song < ApplicationRecord
  belongs_to :user
  belongs_to :genre
  belongs_to :focus_point
  has_many :evaluations, dependent: :destroy
  has_many :favorites
  has_many :favorited_by, through: :favorites, source: :user
  has_many :comments, dependent: :destroy
  attr_accessor :genre_name

  before_validation :set_genre, on: [:create, :update]
  before_save :convert_to_embed_url
  validate :valid_embed_url
  validate :validate_video, on: :create
  validates :title, presence: true, length: { maximum: 255 }
  validates :artist, presence: true, length: { maximum: 255 }
  validates :embed_url, presence: true, length: { maximum: 255 }, uniqueness: true
  validates :software_name, presence: true, length: { maximum: 255 }

  SYNTHESIZER_KEYWORDS = ["初音ミク", "VOCALOID", "可不", "CeVIO", "Synthesizer", "UTAU", "VOICEBOX", "flower", "巡音ルカ", "鏡音",
                          "ボーカロイド", "ずんだもん", "重音テト"]

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

  def convert_to_embed_url
    self.embed_url = UrlConverter.to_embed_url(embed_url)
  end

  def valid_embed_url
    return if embed_url.blank?
  
    youtube_regex = %r{\Ahttps?://(www\.youtube\.com/watch\?v=|www\.youtube\.com/embed/|youtu\.be/)[^/\s]+\z}
    niconico_regex = %r{\Ahttps?://(www\.nicovideo\.jp/watch/|embed\.nicovideo\.jp/watch/)[^/\s]+\z}
    
    unless embed_url =~ youtube_regex || embed_url =~ niconico_regex
      errors.add(:embed_url, "のフォーマットが正しくありません(動画再生画面のURLを入力して下さい)")
    end
  end

  def set_genre
    return if genre_name.blank?
    genre = Genre.find_or_create_by(name: genre_name)
    self.genre_id = genre.id
  end

  def validate_video
    video_info = VideoInfoFetcher.get_video_info(embed_url)
    return if video_info && video_uses_synthesized_music?(video_info)

    errors.add(:embed_url, "に入力した楽曲は音声合成ソフトウェアを使用している必要があります。動画のタイトル、概要欄、タグ等に音声合成ソフト関連のワードが含まれているか確認して下さい。")
  end

  def video_uses_synthesized_music?(video_info)
    title = video_info[:title].downcase
    description = video_info[:description].downcase
    tags = video_info[:tags] ? video_info[:tags].map(&:downcase) : []
  
    SYNTHESIZER_KEYWORDS.any? do |keyword|
      keyword = keyword.downcase
      title.include?(keyword) || description.include?(keyword) || tags.include?(keyword)
    end
  end
end

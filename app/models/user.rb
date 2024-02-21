class User < ApplicationRecord
  authenticates_with_sorcery!

  has_one :profile
  has_many :comments
  has_many :favorites
  has_many :evaluations
  has_many :songs
  has_many :evaluations, dependent: :destroy
  has_one :profile, dependent: :destroy
  has_many :favorites
  has_many :favorited_songs, through: :favorites, source: :song
  has_many :comments, dependent: :destroy
  has_many :following_relationships, foreign_key: :follower_id, class_name: 'Follow'
  has_many :following, through: :following_relationships, source: :followed
  has_many :follower_relationships, foreign_key: :followed_id, class_name: 'Follow'
  has_many :followers, through: :follower_relationships, source: :follower
  after_create :create_user_profile

  enum role: { general: 0, artist: 1 }

  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 8 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :reset_password_token, uniqueness: true, allow_nil: true
  validates :role, presence: true, inclusion: { in: User.roles.keys, message: "を選択してください" }

  private

  def create_user_profile
    Profile.create(user: self)
  end
end

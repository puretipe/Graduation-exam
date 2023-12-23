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
  after_create :create_user_profile

  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 8 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  private

  def create_user_profile
    Profile.create(user: self)
  end
end

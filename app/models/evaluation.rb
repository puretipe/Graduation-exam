class Evaluation < ApplicationRecord
  belongs_to :user
  belongs_to :song

  enum evaluation_point: {
    melody: 0,
    lyrics: 1,
    chord: 2,
    beat: 3,
    sound: 4,
    atmosphere: 5
  }

  def self.ransackable_attributes(auth_object = nil)
    %w[evaluation_point song_id user_id]
  end

  def self.ransackable_associations(auth_object = nil)
    ['song', 'user']
  end
end

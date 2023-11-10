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
end

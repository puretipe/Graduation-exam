class Song < ApplicationRecord
  belongs_to :user
  belongs_to :genre
  belongs_to :focus_point
end

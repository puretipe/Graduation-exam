class Genre < ApplicationRecord
  has_many :songs

  def self.ransackable_attributes(auth_object = nil)
    %w[name]
  end
end

class Profile < ApplicationRecord
  mount_uploader :profile_image_url, ProfileImageUploader

  belongs_to :user
end

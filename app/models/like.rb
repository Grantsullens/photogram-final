# == Schema Information
#
# Table name: likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  fan_id     :integer
#  photo_id   :integer
#
class Like < ApplicationRecord
  # Direct Associations

  belongs_to :fan, 
             class_name: "User",
             foreign_key: "fan_id",
             counter_cache: true # This will increment the user's likes_count if present

  belongs_to :photo, 
             class_name: "Photo",
             foreign_key: "photo_id",
             counter_cache: true # This will increment the photo's likes_count if present

  # Validations
  validates :photo_id, uniqueness: { scope: :fan_id }
end

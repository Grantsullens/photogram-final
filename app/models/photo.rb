# == Schema Information
#
# Table name: photos
#
#  id             :bigint           not null, primary key
#  caption        :text
#  comments_count :integer
#  image          :string
#  likes_count    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  owner_id       :integer
#
class Photo < ApplicationRecord
  # Direct Associations

  belongs_to :owner, 
             class_name: "User",
             foreign_key: "owner_id"
             # If you've added a `photos_count` column to users, you can enable a counter_cache:
             # counter_cache: true

  has_many :comments, 
           class_name: "Comment",
           foreign_key: "photo_id",
           dependent: :destroy

  has_many :likes, 
           class_name: "Like",
           foreign_key: "photo_id",
           dependent: :destroy

  # Indirect Associations
  has_many :fans,
           through: :likes,
           source: :fan

  # Validations
  # Add any needed validations here
end


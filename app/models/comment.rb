# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  author_id  :integer
#  photo_id   :integer
#
class Comment < ApplicationRecord
  # Direct Associations

  belongs_to :author, 
             class_name: "User",
             foreign_key: "author_id",
             counter_cache: true  # This updates the user's comments_count if present

  belongs_to :photo, 
             class_name: "Photo",
             foreign_key: "photo_id",
             counter_cache: true  # This updates the photo's comments_count if present

  # Validations
  # Add any needed validations here (e.g. presence of body)
end


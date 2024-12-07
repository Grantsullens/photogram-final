# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  comments_count         :integer
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  likes_count            :integer
#  private                :boolean
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Direct Associations

  has_many :photos, 
           class_name: "Photo",
           foreign_key: "owner_id",
           dependent: :destroy

  has_many :comments, 
           class_name: "Comment",
           foreign_key: "author_id",
           dependent: :destroy

  has_many :likes, 
           class_name: "Like",
           foreign_key: "fan_id",
           dependent: :destroy

  has_many :sent_follow_requests, 
           class_name: "FollowRequest",
           foreign_key: "sender_id",
           dependent: :destroy

  has_many :received_follow_requests, 
           class_name: "FollowRequest",
           foreign_key: "recipient_id",
           dependent: :destroy

  # Indirect Associations (if you want easy access to people you are following and who are following you)
  # Only add these if you have the logic for accepted follow requests:
  has_many :accepted_sent_follow_requests,
           -> { where(status: "accepted") },
           class_name: "FollowRequest",
           foreign_key: "sender_id"

  has_many :accepted_received_follow_requests,
           -> { where(status: "accepted") },
           class_name: "FollowRequest",
           foreign_key: "recipient_id"

  has_many :following,
           through: :accepted_sent_follow_requests,
           source: :recipient

  has_many :followers,
           through: :accepted_received_follow_requests,
           source: :sender

  has_many :liked_photos,
           through: :likes,
           source: :photo

  # Validations
  # Add any validations you need, for example:
  # validates :username, presence: true, uniqueness: true
end


class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:feed]

  def index
    @users = User.all.order({ :username => :asc })
    render({ :template => "users/index" })
  end

  def show
    @user = User.find_by!(username: params.fetch("username"))
    @photos = @user.photos.order(created_at: :desc)
    @pending_followers = @user.received_follow_requests
                             .where(status: "pending")
                             .map(&:sender)
    render({ :template => "users/show" })
  end

  def feed
    @user = User.find_by!(username: params[:username])
    
    # Get all users that this user is following
    following_users = @user.following
    
    # Get all photos from followed users, ordered by newest first
    @feed_photos = Photo.where(owner: following_users)
                       .order(created_at: :desc)
    
    render({ :template => "users/feed" })
  end
end

class PhotosController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    matching_photos = Photo.all

    # Filter out private photos unless the user is following the owner
    @list_of_photos = matching_photos.select do |photo|
      !photo.owner.private || 
      (current_user && (current_user == photo.owner || current_user.following.include?(photo.owner)))
    end

    @list_of_photos = @list_of_photos.sort_by(&:created_at).reverse

    render({ :template => "photos/index" })
  end

  def show
    the_id = params.fetch("path_id")
    @the_photo = Photo.find(the_id)
    
    # Check if user can view this photo
    if @the_photo.owner.private && 
       (!current_user || (current_user != @the_photo.owner && !current_user.following.include?(@the_photo.owner)))
      redirect_to photos_path, alert: "You don't have permission to view this photo."
    else
      render({ :template => "photos/show" })
    end
  end

  def create
    return redirect_to photos_path, alert: "You must be signed in to post photos." unless current_user

    the_photo = Photo.new
    the_photo.caption = params.fetch("query_caption")
    the_photo.image = params.fetch("query_image")
    the_photo.owner_id = current_user.id
    the_photo.likes_count = 0
    the_photo.comments_count = 0

    if the_photo.valid?
      the_photo.save
      redirect_to photos_path, notice: "Photo created successfully."
    else
      redirect_to photos_path, alert: the_photo.errors.full_messages.to_sentence
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_photo = Photo.find(the_id)

    if current_user != the_photo.owner
      redirect_to photos_path, alert: "You can only delete your own photos."
    else
      the_photo.destroy
      redirect_to photos_path, notice: "Photo deleted successfully."
    end
  end
end

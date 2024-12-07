class PhotosController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_photo, only: [:show, :update, :destroy]

  def index
    matching_photos = Photo.all
    @list_of_photos = matching_photos.order({ :created_at => :desc })
    render({ :template => "photos/index" })
  end

  def show
    # Check if user can view this photo
    if @the_photo.owner.private && 
       (!current_user || (current_user != @the_photo.owner && !current_user.following.include?(@the_photo.owner)))
      redirect_to photos_path, alert: "You don't have permission to view this photo."
    else
      @comment = Comment.new  # For the comment form
      render({ :template => "photos/show" })
    end
  end

  def create
    the_photo = Photo.new
    the_photo.caption = params.fetch("query_caption", "")
    the_photo.image = params.fetch("query_image", "")
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

  # This action is now tied to POST "/modify_photo/:id"
  def update
    # Only the owner can modify the photo
    if @the_photo.owner == current_user
      @the_photo.caption = params[:query_caption] if params[:query_caption].present?
      @the_photo.image = params[:query_image] if params[:query_image].present?

      if @the_photo.save
        redirect_to photo_path(@the_photo), notice: "Photo updated successfully."
      else
        redirect_to photo_path(@the_photo), alert: @the_photo.errors.full_messages.to_sentence
      end
    else
      redirect_to photo_path(@the_photo), alert: "You can only update your own photos."
    end
  end

  # This action is now tied to GET "/delete_photo/:id"
  def destroy
    # Only the owner can delete the photo
    if current_user == @the_photo.owner
      @the_photo.destroy
      redirect_to photos_path, notice: "Photo deleted successfully."
    else
      redirect_to photos_path, alert: "You can only delete your own photos."
    end
  end

  private

  def set_photo
    @the_photo = Photo.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to photos_path, alert: "Photo not found."
  end

  # Not used directly, but kept for reference if needed
  def photo_params
    params.require(:photo).permit(:caption, :image)
  end
end

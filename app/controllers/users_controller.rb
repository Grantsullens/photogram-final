class UsersController < ApplicationController
  def index
    @users = User.all.order({ :username => :asc })
    render({ :template => "users/index" })
  end

  def show
    @user = User.find_by!(username: params.fetch("username"))
    render({ :template => "users/show" })
  end
end

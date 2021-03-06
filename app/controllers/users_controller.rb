class UsersController < ApplicationController
   before_action :require_user_logged_in, only: [:index, :show, :followings, :followers, :likes]
  include UsersHelper
  
  def index
    @users = User.order(id: :desc).page(params[:page]).per(25)
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order(id: :desc).page(params[:page])
    counts(@user)
  end
 
 

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:success] = 'ユーザーを登録しました'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました'
      render :new
    end
  end

  def followings
    @user = User.find(params[:id])  #URLからidをparams[:id]で取得している
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end
  
  def followers
    @user = User.find(params[:id])  #URLからidをparams[:id]で取得している
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end

  def likes             #あるユーザがお気に入りにした投稿を取得している
    @user = User.find(params[:id])          
    @likes = @user.likes.page(params[:page])
    counts(@user)
  end
  
  
  def rev_microposts       #あるユーザの投稿をお気に入りにしたユーザを取得している
    @micropost = Micropost.find(params[:id])
    @rev_microposts = @micropost.rev_microposts.page(params[:page])
    counts2(@micropost)
  end

private

def user_params
  params.require(:user).permit(:name, :email, :password, :password_confirmation)
end


end

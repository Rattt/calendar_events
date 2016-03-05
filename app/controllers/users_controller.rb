class UsersController < ApplicationController

  before_action :only => [:edit, :update] do
    private_access!
  end

  before_action :set_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = I18n.t('success.created_user')
      sign_in(@user)
      redirect_to edit_user_path(@user)
    else
      render 'new'
    end
  end

  def update
    if @user.update(user_params)
      flash[:success] = I18n.t('success.updated_user')
      redirect_to edit_user_path(@user)
    else
      render :edit
    end
  end

  def edit

  end

  private

  def user_params
    params.require(:user).permit(:full_name, :email, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end


end
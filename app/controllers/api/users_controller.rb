class Api::UsersController < ApplicationController
  def create
    if params[:username].nil? || params[:password].nil?
      render json: {"errors": "invalid input"}, status: :bad_request
      return
    end

    @user = User.new(user_params)

    if @user.save
      render json: @user.serializable_hash, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

    def user_params
      params.permit(:username, :password)
    end
end

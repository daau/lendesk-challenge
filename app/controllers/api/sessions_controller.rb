class Api::SessionsController < ApplicationController
  def create
    if params[:username].nil? || params[:password].nil?
      render json: {"errors": "invalid input"}, status: :bad_request
      return
    end

    @user = User.find(params[:username])

    if @user && @user.authenticate(params[:password])
      render json: @user.serializable_hash
    else
      render json: {"errors": "invalid password"}, status: :unauthorized
    end
  end
end

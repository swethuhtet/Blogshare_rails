class UsersController < ApplicationController
    before_action :authenticate_user! , except: [:forgot_password,:reset_password]
    before_action :find_user, only: [:update,:update_password]

    def profile
      render json: current_user, status: :ok
    end

    def index
      users = User.all
      render json: users
    end

    def show
      user = User.find(params[:id])
      if user
        render json: user, status: 200
      else
        render json: {error: 'Unable to find user'}, status: 400
      end
    end

    def update
      if @user.update(user_params)
          render json: @user, status: 200
      else
          render json: {error: 'Unable to update user'}, status: 400
      end
    end

    def destroy
      @user = User.find(params[:id])
      if @user
        @user.destroy
        render json: @user, status: 200
      else
        render json: {error: 'Unable to delete user', status: 400}
      end
    end

    def find_user
      @user = User.find(params[:id])
    end

    def update_password
      if @user.valid_password?(password_params[:current_password])
        if @user.update(password_params.except(:current_password))
          bypass_sign_in(@user)
          render json: @user, status: 200
        else
          render json: {error: "Unable to update user's password", status: 400}
        end
      else
        render json: {error: 'password do not match', status: 400}
      end
    end

    def forgot_password
      @user = User.find_by(email: params[:email])
      if @user
        result = User.send_password_reset(params[:email])
        if result
          render json: {alert: ["We have sent you an email to your registered email address, 
          please follow the instruction to reset your password." ], status: :created}
        else
          render json: { error: result[:message] }, status: :not_found
        end
      else
        render json: { errors: ["Email address not registered"] }, status: :not_found
      end
    end

    def reset_password
      token = params[:token]

      decoded_token = User.decode_password_reset_token(token)
      if decoded_token
        user = User.find_by(decoded_token[:user_id])
          if user.password_reset_sent_at && user.password_reset_sent_at + 3600 >= Time.zone.now && user.password_reset_token == token
            user.update_reset_password(params[:password])
            session[:user_id] = user.id
            render json: {user: UserSerializer.new(user).serializable_hash, message: ["Your password has been reset."] }, status: :created
          else
            render json: { errors: ["Token has expired."] }, status: :unprocessable_entity
          end
        else
          render json: { errors: ["Email address not registered."] }, status: :not_found
        end
    end

    private
    def user_params
      params.permit(:name,:email,:role,:password)
    end

    def password_params
      params.require(:user).permit(:current_password, :password, :password_confirmation)
    end

    protected 
    def authenticate_user!
      unless user_signed_in?
        render json: { error: 'You need to sign in or sign up before continuing.' }, status: :unauthorized
      end
    end
end

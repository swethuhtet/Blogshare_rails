class RegistrationsController < Devise::RegistrationsController
    include RackSessionsFix
    respond_to :json
    
    private

    # def sign_up_params
    #   params.require(:user).permit(:email, :password, :password_confirmation, :name, :role)
    # end
  
    # def account_update_params
    #   params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :name, :role)
    # end

    def respond_with(current_user, _opts = {})
      if resource.persisted?
        render json: {
          status: {code: 200, message: 'Signed up successfully.'},
          data: UserSerializer.new(current_user).serializable_hash[:data][:attributes],
          token: Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil).first
        }
      else
        render json: {
          status: {message: "User couldn't be created successfully. #{current_user.errors.full_messages.to_sentence}"}
        }, status: :unprocessable_entity
      end
    end
end

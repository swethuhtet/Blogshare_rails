class SessionsController < Devise::SessionsController
    include RackSessionsFix
    respond_to :json

    

    private
    def respond_with(current_user, _opts = {})
        if current_user.persisted?
            render json: {
            status: { code: 200, message: 'Logged in successfully.' },
            data: UserSerializer.new(current_user).serializable_hash[:data][:attributes],
            token: request.env['warden-jwt_auth.token']
            }, status: :ok
        else
            render json: {
            status: { message: "Please check your email and password. #{current_user.errors.full_messages.to_sentence}" }
            }, status: :unprocessable_entity
        end
    end


    def respond_to_on_destroy
        if request.headers['Authorization'].present?
        jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last,'monkey_banana').first
        current_user = User.find(jwt_payload['sub'])
        end
        
        if current_user
        render json: {
            status: 200,
            message: 'Logged out successfully.'
        }, status: :ok
        else
        render json: {
            status: 401,
            message: "Couldn't find an active session."
        }, status: :unauthorized
        end
    end
  end
  
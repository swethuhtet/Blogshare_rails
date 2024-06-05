class ApplicationController < ActionController::API
    include RackSessionsFix
    before_action :configure_permitted_parameters, if: :devise_controller?


    protected
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: %i[name avatar role])
        devise_parameter_sanitizer.permit(:account_update, keys: %i[name avatar])
    end

end

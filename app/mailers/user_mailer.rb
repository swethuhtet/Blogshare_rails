class UserMailer < ApplicationMailer
    default from: 'no-reply@example.com'

    def password_reset_email
        @user = params[:user]
        @token = params[:token] 
        @url = "http://localhost:5173/reset_password/#{@token}"

        mail(to: @user.email, subject: 'Password Reset Instructions')
    end
end

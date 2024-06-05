class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  enum role: { normal_user: 0, author: 1 }  
         
  has_many :blogs, foreign_key: 'user_id'
  
  def self.send_password_reset(email)
    user = find_by(email: email)
    if user 
      token = self.generate_password_reset_token(user.id)
      user.update!(reset_password_token: token, reset_password_sent_at: Time.zone.now)
      UserMailer.with(user: user, token: token).password_reset_email.deliver_now
    end
  end

  def self.update_reset_password(updatedPassword)
    self.update!(password: updatedPassword)      
    self.update!(password_reset_token: nil, password_reset_sent_at: nil)    
  end

  def self.generate_password_reset_token(userId)
    payload = { user_id: userId, exp: 1.hour.from_now.to_i }
    return JWT.encode(payload, 'my_secret_key')
  end 

  def self.decode_password_reset_token(token)
    decoded = JWT.decode(token, 'my_secret_key')[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::DecodeError
    nil
  end
  
end

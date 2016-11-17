class User < ApplicationRecord
  before_save :set_avatar

  validates :username, :email, :password, :password_confirmation, :presence => true
  
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :confirmable,
         :omniauth_providers => [:facebook, :vkontakte, :twitter]

  def self.find_for_oauth(access_token)
    if @user = User.where(:provider => access_token.provider)
               .where(:uid => access_token.uid).first
      @user
    else
      @user = User.create(access_token)
      @user.skip_confirmation!
      @user.save
      @user
    end
  end

end

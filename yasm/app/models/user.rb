class User < ApplicationRecord
  after_save :add_user_role
  before_save :set_avatar

  validates :username, :email, :password, :password_confirmation, :presence => true
  
  include Badginator::Nominee

  has_many :sites
  has_many :pictures
  has_many :comments

  rolify
  acts_as_voter
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :confirmable,
         :omniauth_providers => [:facebook, :vkontakte, :twitter]

  def self.find_for_oauth(access_token)
    if @user = User.where("provider = ? AND uid = ?",
                          access_token.provider,
                          access_token.uid).first
      @user
    else
      @user = User.create(access_token)
      @user.skip_confirmation!
      @user.save
      @user
    end
  end

  def try_add_comment_achievement
    try_add_achievement(:first_comment)
    try_add_achievement(:ten_comments)
    try_add_achievement(:twenty_comments)
  end

  def try_add_site_achievement
    try_add_achievement(:first_site)
    try_add_achievement(:ten_sites)
  end

  private
  def self.create(access_token)
    @user = User.new(:provider => access_token.provider,
                    :uid => access_token.uid,
                    :username => access_token.info.name,
                    :avatar => access_token.info.image,
                    :email => "#{access_token.uid}@temp.tmp",
                    :password => Devise.friendly_token[0,20])
    @user
  end

  def add_user_role
    if User.count == 1
      self.add_role :admin
    else
      self.add_role :user
    end
  end

  def try_add_achievement(achievement)
    status = try_award_badge(achievement)
    if status.code == Badginator::WON
      puts "Achievement added: " + status.awarded_badge.badge.name
    end
  end

  def commentators_rating
    comments.length
  end

  def medalists_rating
    badges.length
  end

  def creators_rating
    sites.length
  end

  def set_avatar
    self.avatar ||= "https://res.cloudinary.com/alex-pat-test-cloud/image/upload/v1471635483/nsp1ckhnwr0kkigh77gt.png"
  end
end

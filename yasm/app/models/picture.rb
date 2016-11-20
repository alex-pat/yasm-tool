class Picture < ApplicationRecord
  belongs_to :user

  def self.update(user, params)
    picture = user.pictures.find_by public_id: params["public_id"]
    picture["public_id"] = Cloudinary::Uploader.upload(params["new_url"], :format => 'png')["public_id"]
    picture.save
  end
end

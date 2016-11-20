class Block < ApplicationRecord
  belongs_to :page
  has_many :components, dependent: :destroy
end

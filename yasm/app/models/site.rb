class Site < ApplicationRecord
  validates :title, :description, :logo, :theme, :presence => true

  resourcify
  belongs_to :user
  has_many :pages, dependent: :destroy

  acts_as_taggable
  acts_as_votable
  acts_as_commentable

  searchable do
    text :title, stored: true
    text :description, stored: true
  end
end

class Site < ApplicationRecord
  validates :title, :description, :theme, :presence => true

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

  def rating
    weighted_score / get_upvotes.length.to_f
  end
end

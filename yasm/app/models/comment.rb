class Comment < ActiveRecord::Base
  validates :comment, :presence => true

  belongs_to :user
  belongs_to :commentable, :polymorphic => true

  include ActsAsCommentable::Comment

  default_scope -> { order('created_at ASC') }

  resourcify

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  # NOTE: Comments belong to a user

  searchable do
    text :comment, stored: true
  end

end

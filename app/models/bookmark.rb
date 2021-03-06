class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :article
  validates :user_id, uniqueness: { scope: :article_id }
  validates :user_id, presence: true
  validates :article_id, presence: true
end

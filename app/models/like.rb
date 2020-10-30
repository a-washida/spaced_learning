class Like < ApplicationRecord
  validates :share_id,
            presence: true,
            uniqueness: { case_sensitive: true, scope: :user_id, message: 'は1つの問題に1度だけ可能です' }

  belongs_to :user
  belongs_to :share
end

class Group < ApplicationRecord
  validates :name,
    presence: true,
    uniqueness: { case_sensitive: true, scope: :user_id },
    length: { maximum: 16 }

  belongs_to :user
  has_many :question_answers, dependent: :destroy
end

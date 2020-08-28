class Record < ApplicationRecord
  with_options presence: true do
    validates :create_count, numericality: { greater_than_or_equal_to: 0 }
    validates :review_count, numericality: { greater_than_or_equal_to: 0 }
    validates :date, uniqueness: { case_sensitive: true }
  end

  belongs_to :user
end

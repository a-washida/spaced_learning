class Option < ApplicationRecord
  with_options presence: true do
    with_options numericality: { greater_than: 0 } do
      validates :interval_of_ml1
      validates :interval_of_ml2
      validates :interval_of_ml3
      validates :interval_of_ml4
    end
    validates :easiness_factor, numericality: { greater_than_or_equal_to: 130, less_than_or_equal_to: 250 }
  end

  belongs_to :user
end

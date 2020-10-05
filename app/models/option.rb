class Option < ApplicationRecord
  with_options presence: true do
    with_options numericality: { greater_than: 0 } do
      validates :interval_of_ml1
      validates :interval_of_ml2, must_greater_than_or_equal_to_lower_ml: { with: '記憶度1' }
      validates :interval_of_ml3, must_greater_than_or_equal_to_lower_ml: { with: '記憶度2' }
      validates :interval_of_ml4, must_greater_than_or_equal_to_lower_ml: { with: '記憶度3' }
    end
    validates :easiness_factor, numericality: { greater_than_or_equal_to: 130, less_than_or_equal_to: 250 }
  end

  # validate :interval_of_ml2_must_greater_than_or_equal_to_ml1



  belongs_to :user

  # private


  # def interval_of_ml3_must_greater_than_or_equal_to_ml4
  #   return if interval_of_ml3 >= interval_of_ml2
  #   errors.add(:interval_of_ml3, 'に..より小さい値は設定できません')
  # end

  # def interval_of_ml4_must_greater_than_or_equal_to_ml3
  #   return if interval_of_ml4 >= interval_of_ml3
  #   errors.add(:interval_of_ml4, 'に..より小さい値は設定できません')
  # end
end

class ShareCategory

  include ActiveModel::Model
  attr_accessor :category_first_id, :category_second, :question_answer_id

  validates :category_first_id, presence: true
  validates :category_second, presence: true, length: { maximum: 16 }

  def save
    category = CategorySecond.where(name: category_second).first_or_initialize(category_first_id: category_first_id)
    category.save
    Share.create(question_answer_id: question_answer_id, category_second_id: category.id)
  end

end
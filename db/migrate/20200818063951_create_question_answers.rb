class CreateQuestionAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :question_answers do |t|
      t.text       :question
      t.text       :answer
      t.date       :display_date, null: false
      t.integer    :memory_level, null: false
      t.integer    :repeat_count, null: false
      t.references :user,         foreign_key: true
      t.references :group,        foreign_key: true
      t.timestamps
    end
  end
end

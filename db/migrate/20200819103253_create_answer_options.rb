class CreateAnswerOptions < ActiveRecord::Migration[6.0]
  def change
    create_table :answer_options do |t|
      t.references :question_answer, foreign_key: true
      t.integer :font_size_id,       null: false
      t.integer :image_size_id,      null: false
      t.timestamps
    end
  end
end

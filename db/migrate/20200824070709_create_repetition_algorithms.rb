class CreateRepetitionAlgorithms < ActiveRecord::Migration[6.0]
  def change
    create_table :repetition_algorithms do |t|
      t.float :interval, null: false
      t.integer :easiness_factor, null: false
      t.references :question_answer, foreign_key: true
      t.timestamps
    end
  end
end

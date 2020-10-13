class CreateShares < ActiveRecord::Migration[6.0]
  def change
    create_table :shares do |t|
      t.references :question_answer, foreign_key: true
      t.references :category_second, foreign_key: true
      t.timestamps
    end
  end
end

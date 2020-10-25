class CreateCategorySeconds < ActiveRecord::Migration[6.0]
  def change
    create_table :category_seconds do |t|
      t.string  :name,              null: false
      t.integer :category_first_id, null: false
      t.timestamps
    end
  end
end

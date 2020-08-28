class CreateRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :records do |t|
      t.integer    :create_count, null: false
      t.integer    :review_count, null: false
      t.date       :date,         null: false
      t.references :user,         foreign_key: true
      t.timestamps
    end
  end
end

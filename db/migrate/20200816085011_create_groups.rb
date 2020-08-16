class CreateGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :groups do |t|
      t.string :name,     null: false, unique: true
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end

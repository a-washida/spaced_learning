class CreateOptions < ActiveRecord::Migration[6.0]
  def change
    create_table :options do |t|
      t.integer    :interval_of_ml1,    null: false
      t.integer    :interval_of_ml2,    null: false
      t.integer    :interval_of_ml3,    null: false
      t.integer    :interval_of_ml4,    null: false
      t.integer    :upper_limit_of_ml1, null: false
      t.integer    :upper_limit_of_ml2, null: false
      t.integer    :easiness_factor,    null: false
      t.references :user,               foreign_key: true
      t.timestamps
    end
  end
end

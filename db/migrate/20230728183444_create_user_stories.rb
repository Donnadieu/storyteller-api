class CreateUserStories < ActiveRecord::Migration[7.0]
  def change
    create_table :user_stories do |t|
      t.references :user, null: false, foreign_key: true
      t.references :story, null: false, foreign_key: true
      t.datetime :purchased_at
      t.datetime :expires_at
      t.datetime :activated_at
      t.datetime :deactivated_at
      t.string :notes      

      t.timestamps
    end
  end
end

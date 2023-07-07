# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :image
      t.string :email, null: false, index: { unique: true }
      t.string :provider
      
      t.timestamps null: false
    end
  end
end

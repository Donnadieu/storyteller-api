# frozen_string_literal: true

class AddUuidToAllTables < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  TABLES = [
    :oauth_access_tokens,
    :oauth_access_grants,
    :oauth_applications,
    :flipper_features, # Just adding this for now. Won't complete migration in phase 2 (if at all)
    :flipper_gates, # Just adding this for now. Won't complete migration in phase 2 (if at all)
    :user_stories,
    :users,
    :stories
  ].freeze

  def up
    TABLES.each do |table|
      add_column table, :uuid, :uuid
      change_column_default table, :uuid, 'gen_random_uuid()'

      safety_assured do
        execute <<~SQL
          UPDATE #{table} SET uuid = gen_random_uuid() WHERE uuid IS NULL
        SQL
        sleep(0.01)
        execute "ALTER TABLE #{table} ALTER COLUMN uuid SET NOT NULL;"
        add_index table, :uuid, unique: true
      end
    end
  end

  def down
    TABLES.each do |table|
      remove_column table, :uuid
    end
  end
end

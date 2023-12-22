# frozen_string_literal: true

# Doc for migrating to UUID from integer: https://ruby.mobidev.biz/posts/moving-from-id-to-uuid-in-existing-app
# Doc for using UUID with Doorkeeper: https://github.com/doorkeeper-gem/doorkeeper/wiki/Using-PostgreSQL-UUIDs-as-primary-keys-with-Doorkeeper

# 20231222125635
class AddUuidToDoorkeeperTables < ActiveRecord::Migration[7.0]
  TABLES = %i[
    oauth_access_grants
    oauth_access_tokens
    oauth_applications
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

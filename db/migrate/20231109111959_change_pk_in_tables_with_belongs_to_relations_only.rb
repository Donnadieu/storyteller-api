# frozen_string_literal: true

require 'change_pk'

# 20231109111959
class ChangePkInTablesWithBelongsToRelationsOnly < ActiveRecord::Migration[7.0]
  include ChangePK

  # NOTE: These are tables with :belongs_to relations only as well as
  #   tables without complex FK relations (which will be completed later,
  #   possibly in phase 2)
  #
  # NOTE: Tables left to address (possibly in phase 2):
  #   - oauth_access_grants
  #   - oauth_access_tokens
  #   - oauth_applications
  #   - stories
  #   - users
  #
  TABLES = %i[flipper_features flipper_gates user_stories].freeze

  disable_ddl_transaction!

  def up
    TABLES.each do |table|
      # NOTE: This is dangerous - only attempting this because we haven't
      #   launched the app yet
      safety_assured do
        add_column table, :numeric_id, :bigint

        execute <<~SQL
          UPDATE #{table} SET numeric_id = id WHERE numeric_id IS NULL
        SQL
        sleep(0.01)

        execute "ALTER TABLE #{table} DROP CONSTRAINT IF EXISTS #{table}_pkey;"
        execute "CREATE SEQUENCE #{table}_numeric_id_seq;"
        execute "ALTER SEQUENCE #{table}_numeric_id_seq OWNED BY #{table}.numeric_id;"
        # execute "ALTER TABLE #{table} ALTER COLUMN numeric_id SET DEFAULT nextval('#{table}_numeric_id_seq'::regclass);"
        # execute "ALTER TABLE #{table} ALTER COLUMN numeric_id SET NOT NULL;"

        remove_column table, :id
        rename_column table, :uuid, :id
        change_column_default table, :numeric_id, "nextval('#{table}_numeric_id_seq'::regclass)"
        # TODO: Add constraint on numeric_id to be NOT NULL (and perhaps UNIQUE)

        change_pk(table)
      end
    end
  end

  def down
    TABLES.each do |table|
      # NOTE: This is dangerous - only attempting this because we haven't
      #   launched the app yet
      safety_assured do
        rename_column table, :id, :uuid
        rename_column table, :numeric_id, :id
        change_column_default table, :id, "nextval('#{table}_id_seq'::regclass)"
        change_pk(table)
      end
    end
  end
end

# frozen_string_literal: true

require_relative '../../lib/change_pk'

# 20231222130821
class ChangePkInDoorkeeperTables < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  include ChangePK

  TABLES = %i[
    oauth_access_grants
    oauth_access_tokens
    oauth_applications
  ].freeze

  APPLICATION_FK_TABLES = %i[
    oauth_access_grants
    oauth_access_tokens
  ].freeze

  def up
    pop_foreign_key_constraints do
      TABLES.each do |table|
        safety_assured do
          rename_column table, :id, :numeric_id
          rename_column table, :uuid, :id

          execute <<~SQL
            DROP SEQUENCE IF EXISTS #{table}_id_seq CASCADE;
          SQL

          execute <<~SQL
            CREATE SEQUENCE IF NOT EXISTS #{table}_numeric_id_seq OWNED BY #{table}.numeric_id;
          SQL

          change_column_default table,
                                :numeric_id,
                                proc { "nextval('#{table}_numeric_id_seq'::regclass)" }
        end
        change_pk(table)
      end

      APPLICATION_FK_TABLES.each do |table|
        safety_assured do
          rename_column table, :application_id, :numeric_application_id
          add_column table, :application_id, :uuid
          execute <<~SQL
            UPDATE #{table}
            SET application_id = oauth_applications.id
            FROM oauth_applications
            WHERE #{table}.numeric_application_id = oauth_applications.numeric_id
          SQL
          add_foreign_key table,
                          :oauth_applications,
                          column: :application_id,
                          validate: false
        end
      end
    end
  end

  def down
    pop_foreign_key_constraints do
      TABLES.each do |table|
        safety_assured do
          rename_column table, :id, :uuid
          rename_column table, :numeric_id, :id

          execute <<~SQL
            DROP SEQUENCE IF EXISTS #{table}_numeric_id_seq CASCADE;
          SQL

          execute <<~SQL
            CREATE SEQUENCE IF NOT EXISTS #{table}_id_seq OWNED BY #{table}.id;
          SQL

          change_column_default table,
                                :id,
                                proc { "nextval('#{table}_id_seq'::regclass)" }
        end
        change_pk(table)
      end

      APPLICATION_FK_TABLES.each do |table|
        safety_assured do
          rename_column table, :application_id, :application_uuid
          add_column table, :application_id, :bigint

          execute <<~SQL
            UPDATE #{table}
            SET application_id = oauth_applications.id
            FROM oauth_applications
            WHERE #{table}.application_uuid = oauth_applications.uuid
          SQL

          add_foreign_key table,
                          :oauth_applications,
                          column: :application_id,
                          validate: false

          remove_column table, :numeric_application_id if column_exists?(table, :numeric_application_id)
          remove_column table, :application_uuid if column_exists?(table, :application_id)
        end
      end
    end
  end

  private

  def pop_foreign_key_constraints(&block)
    if foreign_key_exists?(:oauth_access_grants,
                           :oauth_applications,
                           column: :application_id)
      remove_foreign_key(:oauth_access_grants,
                         :oauth_applications,
                         column: :application_id,
                         validate: false)
    end

    if foreign_key_exists?(:oauth_access_tokens,
                           :oauth_applications,
                           column: :application_id)
      remove_foreign_key(:oauth_access_tokens,
                         :oauth_applications,
                         column: :application_id,
                         validate: false)
    end

    yield block
  end
end

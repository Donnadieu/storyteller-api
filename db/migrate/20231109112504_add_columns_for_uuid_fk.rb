# frozen_string_literal: true

# 20231109112504 This is step 4: https://ruby.mobidev.biz/posts/moving-from-id-to-uuid-in-existing-app/#step-4-create-uuid-columns-for-fks
class AddColumnsForUuidFk < ActiveRecord::Migration[7.0]
  TABLES_WITH_FK = {
    oauth_access_grants: %i[resource_owner_uuid application_uuid],
    oauth_access_tokens: %i[resource_owner_uuid application_uuid],
    user_stories: %i[user_uuid story_uuid]
  }.freeze

  def up
    TABLES_WITH_FK.each do |table, fk_names|
      fk_names.each do |fk_name|
        add_column table, fk_name, :uuid
      end
    end
  end

  def down
    TABLES_WITH_FK.each do |table, fk_names|
      fk_names.each do |fk_name|
        remove_column table, fk_name
      end
    end
  end
end

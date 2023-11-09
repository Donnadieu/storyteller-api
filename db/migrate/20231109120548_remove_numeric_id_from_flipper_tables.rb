# frozen_string_literal: true

# 20231109120548
class RemoveNumericIdFromFlipperTables < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      remove_column :flipper_features, :numeric_id, :bigint
      remove_column :flipper_gates, :numeric_id, :bigint
    end
  end
end

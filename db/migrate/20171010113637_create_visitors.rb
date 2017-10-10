class CreateVisitors < ActiveRecord::Migration[5.1]
  # :reek:FeatureEnvy
  def change
    create_table :visitors do |table|
      table.string :instagram_token
      table.timestamps
    end
  end
end

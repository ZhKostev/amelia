class CreateTagSearches < ActiveRecord::Migration[5.1]
  # :reek:FeatureEnvy
  def change
    create_table :tag_searches do |table|
      table.integer :tag_id, null: false
      table.integer :visitor_id, null: false

      table.timestamps
    end
    add_index :tag_searches, [:visitor_id, :tag_id], name: "visitor_id_tag_id_index"
  end
end

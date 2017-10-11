class CreateTags < ActiveRecord::Migration[5.1]
  # :reek:FeatureEnvy
  def change
    create_table :tags do |table|
      table.string :name, null: false
      table.timestamps
    end

    add_index :tags, [:name], name: "name_index", unique: true
  end
end

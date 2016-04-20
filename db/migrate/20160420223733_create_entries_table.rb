class CreateEntriesTable < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :title
      t.string :content
      t.string :url
      t.string :publisher
      t.integer :feed_id
    end
  end
end

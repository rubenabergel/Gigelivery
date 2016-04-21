class AddColumnPublishedAtToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :published_at, :datetime
  end
end

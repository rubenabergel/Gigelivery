class RemoveColumnsFromEntries < ActiveRecord::Migration
  def change
    remove_column :entries, :published_at, :datetime
    remove_column :entries, :publisher, :string
    add_column :entries, :published, :datetime
  end
end

class CreateFeedsTable < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :name
      t.string :url
      t.string :description
    end
  end
end

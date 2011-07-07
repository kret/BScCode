class CreatePreferences < ActiveRecord::Migration
  def self.up
    create_table :preferences do |t|
      t.references :user
      t.references :book
      t.boolean :likes
      t.boolean :possesses
      t.boolean :wants_to_read
      t.boolean :wants_to_give_away

      t.timestamps
    end
  end

  def self.down
    drop_table :preferences
  end
end

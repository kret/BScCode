class CreateContributions < ActiveRecord::Migration
  def self.up
    create_table :contributions do |t|
      t.references :person
      t.references :book

      t.timestamps
    end
  end

  def self.down
    drop_table :contributions
  end
end

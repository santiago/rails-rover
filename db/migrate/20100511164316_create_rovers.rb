class CreateRovers < ActiveRecord::Migration
  def self.up
    create_table :rovers do |t|
      t.timestamps
    end
    add_column :rovers, :x, :integer
    add_column :rovers, :y, :integer
  end

  def self.down
    drop_table :rovers
    remove_column :rovers, :x
    remove_column :rovers, :y
  end
end

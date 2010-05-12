class AddLabelToRovers < ActiveRecord::Migration
  def self.up
    add_column :rovers, :label, :string
  end

  def self.down
    remove_column :rovers, :label
  end
end

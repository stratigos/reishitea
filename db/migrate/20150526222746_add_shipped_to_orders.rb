class AddShippedToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :shipped, :boolean
    add_index :orders, :shipped
  end
end

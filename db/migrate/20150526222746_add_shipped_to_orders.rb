class AddShippedToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :shipped, :boolean, default: false, after: :quantity
    add_index :orders, :shipped
  end
end

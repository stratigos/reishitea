class AlterOrdersChangeColumnPostalToVarchar < ActiveRecord::Migration
  def change
    change_column :orders, :postal, :string, :limit => 10
  end
end

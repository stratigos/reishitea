class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :name
      t.string :street
      t.string :city
      t.string :state
      t.string :country
      t.integer :postal
      t.integer :quantity

      t.timestamps null: false
    end
  end
end

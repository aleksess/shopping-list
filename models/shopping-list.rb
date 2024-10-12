require 'active_record'

conn = { adapter: 'sqlite3', database: 'database.db' }
ActiveRecord::Base.establish_connection(conn)

class ShoppingList < ActiveRecord::Base
  connection.create_table :shopping_lists, if_not_exists: true do |t|
    t.string :name
    t.boolean :saved
  end

  has_many :shopping_list_entries
end

class ShoppingListEntry < ActiveRecord::Base
  connection.create_table :shopping_list_entries, if_not_exists: true do |t|
    t.belongs_to :shopping_list
    t.string :item
    t.integer :amount, null: true
    t.boolean :done, default: false
  end

  belongs_to :shopping_list

  delegate :saved, to: :shopping_list
end

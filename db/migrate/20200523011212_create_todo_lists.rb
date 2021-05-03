class CreateTodoLists < ActiveRecord::Migration[5.2]
  def change
    create_table :todo_lists do |t|
      t.belongs_to :user
      t.string :title
      t.text :whitelisted_from_numbers, array: true, default: []

      t.timestamps
    end
  end
end
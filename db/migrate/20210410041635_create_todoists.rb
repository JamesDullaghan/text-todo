class CreateTodoists < ActiveRecord::Migration[5.2]
  def change
    create_table :todoists do |t|
      t.belongs_to :todo_list
      t.string :auth_token
      t.string :list_name

      t.timestamps
    end
  end
end
